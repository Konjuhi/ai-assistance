import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/image_entity.dart';

abstract class ImageRepository {
  Stream<Either<Failure, List<ImageEntity>>> getImages(String userId);
  Future<Either<Failure, void>> addImage(ImageEntity image, String userId);
}
