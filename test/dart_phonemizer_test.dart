import 'package:test/test.dart';
import 'package:dart_phonemizer/dart_phonemizer.dart';

void main() {
  group('Phonemizer', () {
    late Phonemizer phonemizer;

    setUp(() {
      phonemizer = Phonemizer();
    });

    tearDown(() {
      phonemizer.dispose();
    });

    test('phonemizes English text correctly', () {
      phonemizer.setLanguage('en-us');
      final phonemes = phonemizer.phonemize('hello world');
      expect(phonemes, equals('h_ə_l_oʊ w_ɜː_l_d'));
    });

    test('phonemizes English text with stress', () {
      phonemizer.setLanguage('en-us');
      final phonemes = phonemizer.phonemize('hello world', withStress: true);
      expect(phonemes, equals('h_ə_l_ˈoʊ w_ˈɜː_l_d'));
    });

    test('phonemizes French text correctly', () {
      phonemizer.setLanguage('fr-fr');
      final phonemes = phonemizer.phonemize('bonjour le monde');
      expect(phonemes, equals('b_ɔ̃_ʒ_u_ʁ l_ə m_ɔ̃_d'));
    });

    test('uses custom phoneme separator', () {
      phonemizer.setLanguage('en-us');
      final phonemes = phonemizer.phonemize('hello', phonemeSeparator: '-');
      expect(phonemes, equals('h-ə-l-oʊ'));
    });

    test('throws an exception for an invalid language', () {
      expect(() => phonemizer.setLanguage('invalid-lang'), throwsException);
    });
  });
}
