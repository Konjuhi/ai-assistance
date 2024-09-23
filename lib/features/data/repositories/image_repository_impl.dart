import 'package:dartz/dartz.dart';

import '../../common/errors/app_exceptions.dart';
import '../../common/errors/failures.dart';
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
      yield* stream.map(
        (imageModels) => Right(
          imageModels
              .map((model) => ImageEntity(
                    imageUrl: model.imageUrl,
                    prompt: model.prompt,
                    timestamp: model.timestamp,
                  ))
              .toList(),
        ),
      );
    } on AppException catch (e) {
      yield Left(ServerFailure(message: e.message, stackTrace: e.stackTrace));
    } catch (e, stackTrace) {
      yield Left(ServerFailure(message: e.toString(), stackTrace: stackTrace));
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
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message, stackTrace: e.stackTrace));
    } catch (e, stackTrace) {
      return Left(ServerFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }
}
