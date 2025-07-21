# Dart Phonemizer

A Dart library for converting text to phonemes using the eSpeak-NG engine.

This is a minimal implementation that wraps the `espeak-ng` shared library to provide phonemization for various languages.

## Prerequisites

You must have `espeak-ng` installed on your system.

- **Linux (Debian/Ubuntu):** `sudo apt-get install espeak-ng`
- **macOS (Homebrew):** `brew install espeak-ng`
- **Windows:** Download from [eSpeak NG releases](https://github.com/espeak-ng/espeak-ng/releases).

## Usage

### As a Library

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  dart_phonemizer: ^1.0.0
```

Then you can use it in your Dart code:

```dart
import 'package:dart_phonemizer/dart_phonemizer.dart';

void main() {
  final phonemizer = Phonemizer();
  
  phonemizer.setLanguage('en-us');
  var phonemes = phonemizer.phonemize('hello world');
  print(phonemes); // Should print something like: h_ə_l_oʊ w_ɜː_l_d

  phonemizer.setLanguage('fr-fr');
  phonemes = phonemizer.phonemize('bonjour le monde');
  print(phonemes); // Should print something like: b_ɔ̃_ʒ_u_ʁ l_ə m_ɔ̃_d
  
  phonemizer.dispose();
}
```

### As a Command-Line Tool

You can also run it from the command line:

```bash
dart run dart_phonemizer <language> <text>
```

Example:
```bash
dart run dart_phonemizer en-us "hello world"
# Output: h_ə_l_oʊ w_ɜː_l_d
```

## How it works

This library uses `dart:ffi` to call functions from the `espeak-ng` shared library. It's a Dart port of the concepts used in the Python `phonemizer` package.
