import 'package:ai_assistant/common/common.dart';
import 'package:ai_assistant/features/chat/domain/domain.dart';
import 'package:dartz/dartz.dart';

class GenerateImage {
  final ImageRepository repository;

  GenerateImage(this.repository);

  Future<Either<Failure, void>> call(ImageEntity image, String userId) async {
    try {
      await repository.addImage(image, userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
