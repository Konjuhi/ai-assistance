import 'package:ai_assistant/common/errors/failures.dart';
import 'package:dartz/dartz.dart';

import '../repositories/translation_repository.dart';

class DeleteTranslationHistory {
  final TranslationRepository repository;

  DeleteTranslationHistory(this.repository);

  Future<Either<Failure, void>> call(String userId) async {
    try {
      await repository.deleteAllTranslations(userId);
      return const Right(null);
    } catch (e) {
      return Left(
          ServerFailure(message: 'Failed to delete translation history'));
    }
  }
}
