import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/image_entity.dart';
import '../repositories/image_repository.dart';

class GetImages {
  final ImageRepository repository;

  GetImages(this.repository);

  Stream<Either<Failure, List<ImageEntity>>> call(String userId) {
    return repository.getImages(userId);
  }
}
