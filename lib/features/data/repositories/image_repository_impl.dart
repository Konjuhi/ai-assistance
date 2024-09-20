import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/repositories/image_repository.dart';
import '../datasources/firebase_image_datasource.dart';
import '../models/image_model.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageDataSource dataSource;

  ImageRepositoryImpl(this.dataSource);

  @override
  Stream<Either<Failure, List<ImageEntity>>> getImages(String userId) async* {
    try {
      final stream = dataSource.getImages(userId);
      yield* stream.map((imageModels) => Right(imageModels
          .map((model) => ImageEntity(
                imageUrl: model.imageUrl,
                prompt: model.prompt,
                timestamp: model.timestamp,
              ))
          .toList()));
    } catch (e) {
      yield Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addImage(
      ImageEntity image, String userId) async {
    try {
      await dataSource.addImage(
        ImageModel(
          imageUrl: image.imageUrl,
          prompt: image.prompt,
          timestamp: image.timestamp,
        ),
        userId,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
