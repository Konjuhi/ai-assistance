import 'package:ai_assistant/common/errors/failures.dart';
import 'package:ai_assistant/features/chat/domain/entities/translation_entity.dart';
import 'package:ai_assistant/features/chat/domain/repositories/translation_repository.dart';
import 'package:dartz/dartz.dart';

class FetchTranslationHistory {
  final TranslationRepository repository;

  FetchTranslationHistory(this.repository);

  Future<Either<Failure, List<TranslationEntity>>> call(String userId) async {
    try {
      final history = await repository.fetchTranslationHistory(userId);
      return Right(history);
    } catch (e) {
      return Left(
          ServerFailure(message: 'Failed to fetch translation history'));
    }
  }
}
