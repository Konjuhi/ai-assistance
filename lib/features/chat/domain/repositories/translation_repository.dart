import '../entities/translation_entity.dart';

abstract class TranslationRepository {
  Future<TranslationEntity> translateText(String from, String to, String text);
  Future<void> saveTranslation(String userId, TranslationEntity translation);
}
