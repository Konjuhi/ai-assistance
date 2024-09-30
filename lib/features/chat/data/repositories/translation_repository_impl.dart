import 'package:ai_assistant/features/chat/data/datasources/translation_datasource.dart';
import 'package:ai_assistant/features/chat/data/models/translation_model.dart';
import 'package:ai_assistant/features/chat/domain/entities/translation_entity.dart';
import 'package:ai_assistant/features/chat/domain/repositories/translation_repository.dart';

class TranslationRepositoryImpl implements TranslationRepository {
  final TranslationDataSource dataSource;

  TranslationRepositoryImpl(this.dataSource);

  @override
  Future<TranslationEntity> translateText(String from, String to, String text) {
    return dataSource.translateText(from, to, text);
  }

  @override
  Future<void> saveTranslation(String userId, TranslationEntity translation) {
    return dataSource.saveTranslation(userId, translation as TranslationModel);
  }

  @override
  Future<List<TranslationEntity>> fetchTranslationHistory(String userId) {
    return dataSource.fetchTranslationHistory(userId);
  }

  @override
  Future<void> deleteAllTranslations(String userId) {
    return dataSource.deleteAllTranslations(userId);
  }

  @override
  Map<String, String> getLanguages() {
    return dataSource.getLanguages();
  }
}
