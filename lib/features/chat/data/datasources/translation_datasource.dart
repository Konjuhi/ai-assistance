import 'package:ai_assistant/features/chat/data/datasources/remote/translation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/translation_model.dart';

abstract class TranslationDataSource {
  Future<TranslationModel> translateText(String from, String to, String text);
  Future<void> saveTranslation(String userId, TranslationModel translation);
}

class TranslatorPlusDataSource implements TranslationDataSource {
  final FirebaseFirestore firestore;

  TranslatorPlusDataSource(this.firestore);

  @override
  Future<TranslationModel> translateText(
      String from, String to, String text) async {
    final translatedText = await TranslationService.googleTranslate(
      from: from,
      to: to,
      text: text,
    );

    return TranslationModel(
      originalText: text,
      translatedText: translatedText,
      fromLanguage: from,
      toLanguage: to,
    );
  }

  @override
  Future<void> saveTranslation(String userId, TranslationModel translation) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('translations')
        .add(translation.toMap());
  }
}
