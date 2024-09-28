import 'package:dartz/dartz.dart';

import '../../../../common/errors/failures.dart';
import '../entities/translation_entity.dart';
import '../repositories/translation_repository.dart';

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
