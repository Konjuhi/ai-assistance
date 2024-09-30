import '../entities/translation_entity.dart';

abstract class TranslationRepository {
  Future<TranslationEntity> translateText(String from, String to, String text);
  Future<void> saveTranslation(String userId, TranslationEntity translation);
  Future<List<TranslationEntity>> fetchTranslationHistory(String userId);
  Future<void> deleteAllTranslations(String userId);
  Map<String, String> getLanguages();
}
