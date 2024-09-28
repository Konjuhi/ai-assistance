import 'dart:developer';

import 'package:translator_plus/translator_plus.dart';

class TranslationService {
  static const jsonLang = {
    'Albanian': 'sq',
    'English': 'en',
    'German': 'de',
    'Slovenian': 'sl',
  };

  static Future<String> googleTranslate({
    required String from,
    required String to,
    required String text,
  }) async {
    try {
      final res = await GoogleTranslator().translate(
        text,
        from: jsonLang[from] ?? 'auto',
        to: jsonLang[to] ?? 'en',
      );
      return res.text;
    } catch (e) {
      log('googleTranslateE: $e ');
      return 'Something went wrong!';
    }
  }
}
