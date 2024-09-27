import 'package:ai_assistant/common/errors/failures.dart';
import 'package:ai_assistant/features/chat/domain/repositories/image_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteImage {
  final ImageRepository repository;

  DeleteImage(this.repository);

  Future<Either<Failure, void>> call(String imageId, String userId) async {
    try {
      return await repository.deleteImage(imageId, userId);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
