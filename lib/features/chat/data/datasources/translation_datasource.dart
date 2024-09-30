import 'package:ai_assistant/features/chat/data/datasources/remote/translation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/translation_model.dart';

abstract class TranslationDataSource {
  Future<TranslationModel> translateText(String from, String to, String text);
  Future<void> saveTranslation(String userId, TranslationModel translation);
  Future<List<TranslationModel>> fetchTranslationHistory(String userId);
  Future<void> deleteAllTranslations(String userId);
  Map<String, String> getLanguages();
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
  Future<void> saveTranslation(
      String userId, TranslationModel translation) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('translations')
        .add(translation.toMap());
  }

  @override
  Future<List<TranslationModel>> fetchTranslationHistory(String userId) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('translations')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => TranslationModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> deleteAllTranslations(String userId) async {
    final batch = firestore.batch();
    final querySnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('translations')
        .get();

    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  @override
  Map<String, String> getLanguages() {
    return TranslationService.jsonLang;
  }
}
