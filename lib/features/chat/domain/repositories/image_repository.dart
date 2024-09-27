import 'package:ai_assistant/common/common.dart';
import 'package:ai_assistant/features/chat/domain/domain.dart';
import 'package:dartz/dartz.dart';

abstract class ImageRepository {
  Stream<Either<Failure, List<ImageEntity>>> getImages(String userId);
  Future<Either<Failure, void>> addImage(ImageEntity image, String userId);
  Future<Either<Failure, void>> deleteImage(
      String userId, String imageId); // New method
}
