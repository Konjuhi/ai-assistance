import 'package:ai_assistant/common/errors/failures.dart';
import 'package:dartz/dartz.dart';

import '../entities/translation_entity.dart';
import '../repositories/translation_repository.dart';

class TranslateText {
  final TranslationRepository repository;

  TranslateText(this.repository);

  Future<Either<Failure, TranslationEntity>> call(
      String from, String to, String text) async {
    try {
      final translation = await repository.translateText(from, to, text);
      return Right(translation);
    } catch (e) {
      return Left(ServerFailure(message: 'Translation failed'));
    }
  }

  Future<void> saveTranslation(String userId, TranslationEntity translation) async {
    await repository.saveTranslation(userId, translation);
  }
}
