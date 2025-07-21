import 'dart:io';
import 'package:dart_phonemizer/dart_phonemizer.dart';

void main(List<String> args) {
  if (args.length < 2) {
    print('Usage: dart run dart_phonemizer <language> <text>');
    exit(1);
  }

  final language = args[0];
  final text = args.sublist(1).join(' ');

  try {
    final phonemizer = Phonemizer();
    phonemizer.setLanguage(language);
    final phonemes = phonemizer.phonemize(text);
    print(phonemes);
    phonemizer.dispose();
  } catch (e) {
    print('Error: $e');
    exit(1);
  }
}
