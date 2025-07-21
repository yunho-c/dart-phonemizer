import 'dart:ffi';
import 'package:ffi/ffi.dart';

// espeak_AUDIO_OUTPUT
const audioOutputPlayback = 0;
const audioOutputRetrieval = 1;
const audioOutputSynchronous = 2;
const audioOutputSynchronchPlayback = 3;

// espeak_OPTIONS
const espeakCHARS_UTF8 = 1;
const espeakPHONEMES_IPA = 2;
const espeakENDPAUSE = 0x1000;
const espeakPHONEMES_NO_STRESS = 8;

class EspeakVoice extends Struct {
  external Pointer<Utf8> name;
  external Pointer<Utf8> languages;
  external Pointer<Utf8> identifier;
  @Int32()
  external int gender;
  @Int32()
  external int age;
  @Int32()
  external int variant;
  @Int32()
  external int xx_test;
  @Int32()
  external int score;
  external Pointer<Void> spare;
}

typedef EspeakInitializeNative = Int32 Function(
    Int32, Int32, Pointer<Utf8>, Int32);
typedef EspeakInitializeDart = int Function(int, int, Pointer<Utf8>, int);

typedef EspeakSetVoiceByNameNative = Int32 Function(Pointer<Utf8>);
typedef EspeakSetVoiceByNameDart = int Function(Pointer<Utf8>);

typedef EspeakTextToPhonemesNative = Pointer<Utf8> Function(
    Pointer<Pointer<Utf8>>, Int32, Int32);
typedef EspeakTextToPhonemesDart = Pointer<Utf8> Function(
    Pointer<Pointer<Utf8>>, int, int);

typedef EspeakTerminateNative = Int32 Function();
typedef EspeakTerminateDart = int Function();

typedef EspeakInfoNative = Pointer<Utf8> Function(Pointer<Pointer<Utf8>>);
typedef EspeakInfoDart = Pointer<Utf8> Function(Pointer<Pointer<Utf8>>);

typedef EspeakListVoicesNative = Pointer<Pointer<EspeakVoice>> Function(
    Pointer<EspeakVoice>);
typedef EspeakListVoicesDart = Pointer<Pointer<EspeakVoice>> Function(
    Pointer<EspeakVoice>);
