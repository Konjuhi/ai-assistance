import '../../domain/entities/translation_entity.dart';
import '../../domain/repositories/translation_repository.dart';
import '../datasources/translation_datasource.dart';
import '../models/translation_model.dart';

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
}
