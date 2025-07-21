import 'dart:ffi';
import 'dart:io' show Platform;
import 'package:ffi/ffi.dart';
import 'espeak_ffi.dart';

class Phonemizer {
  late final DynamicLibrary _espeakLib;
  late final EspeakInitializeDart _initialize;
  late final EspeakSetVoiceByNameDart _setVoiceByName;
  late final EspeakTextToPhonemesDart _textToPhonemes;
  late final EspeakTerminateDart _terminate;

  Phonemizer() {
    _espeakLib = _openEspeakLib();
    _initialize = _espeakLib
        .lookup<NativeFunction<EspeakInitializeNative>>('espeak_Initialize')
        .asFunction();
    _setVoiceByName = _espeakLib
        .lookup<NativeFunction<EspeakSetVoiceByNameNative>>('espeak_SetVoiceByName')
        .asFunction();
    _textToPhonemes = _espeakLib
        .lookup<NativeFunction<EspeakTextToPhonemesNative>>('espeak_TextToPhonemes')
        .asFunction();
    _terminate = _espeakLib
        .lookup<NativeFunction<EspeakTerminateNative>>('espeak_Terminate')
        .asFunction();

    // Initialize espeak
    final espeakDataPath = Platform.environment['ESPEAK_DATA_PATH'];
    final pathPtr = espeakDataPath != null ? espeakDataPath.toNativeUtf8() : nullptr;
    final result = _initialize(audioOutputSynchronous, 0, pathPtr, 0);
    if (pathPtr != nullptr) {
      calloc.free(pathPtr);
    }

    if (result < 0) {
      throw Exception('Failed to initialize eSpeak-ng');
    }
  }

  DynamicLibrary _openEspeakLib() {
    if (Platform.isMacOS) {
      const libName = 'libespeak-ng.dylib';
      final paths = [
        libName,
        '/opt/homebrew/opt/espeak-ng/lib/$libName',
        '/opt/homebrew/lib/$libName',
        '/usr/local/lib/$libName',
      ];
      for (final path in paths) {
        try {
          return DynamicLibrary.open(path);
        } catch (e) {
          // Try next path
        }
      }
    } else if (Platform.isWindows) {
      return DynamicLibrary.open('espeak-ng.dll');
    } else {
      // Assuming Linux
      try {
        return DynamicLibrary.open('libespeak-ng.so.1');
      } catch (e) {
        return DynamicLibrary.open('libespeak-ng.so');
      }
    }
    throw Exception('Failed to open eSpeak-ng library. Make sure it is installed.');
  }

  void setLanguage(String language) {
    final langStr = language.toNativeUtf8();
    final result = _setVoiceByName(langStr);
    calloc.free(langStr);
    if (result != 0) {
      throw Exception('Failed to set language to $language');
    }
  }

  String phonemize(String text,
      {String phonemeSeparator = '_', bool withStress = false}) {
    final textUtf8 = text.toNativeUtf8();
    final textPtr = calloc<Pointer<Utf8>>();
    textPtr.value = textUtf8;

    // Always use '_' as the separator for espeak, we'll replace it later.
    int phonemeMode = ('_'.codeUnitAt(0) << 8) | espeakPHONEMES_IPA;
    final textMode = espeakCHARS_UTF8;

    final phonemes = <String>[];
    while (textPtr.value.address != nullptr.address) {
      final resultPtr = _textToPhonemes(textPtr, textMode, phonemeMode);
      if (resultPtr.address != nullptr.address) {
        phonemes.add(resultPtr.toDartString());
      } else {
        break;
      }
    }

    calloc.free(textUtf8);
    calloc.free(textPtr);

    var result = phonemes.join(' ').trim();
    if (!withStress) {
      result = result.replaceAll(RegExp(r"[ˈˌ'-]+"), '');
    }
    if (phonemeSeparator != '_') {
      result = result.replaceAll('_', phonemeSeparator);
    }
    return result;
  }

  void dispose() {
    _terminate();
  }
}
