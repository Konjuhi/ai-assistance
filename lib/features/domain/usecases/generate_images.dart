import 'package:dartz/dartz.dart';

import '../../common/errors/failures.dart';
import '../entities/image_entity.dart';
import '../repositories/image_repository.dart';

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
