import 'package:ai_assistant/common/errors/app_exceptions.dart';
import 'package:ai_assistant/common/errors/failures.dart';
import 'package:ai_assistant/features/chat/data/datasources/firebase_image_datasource.dart';
import 'package:ai_assistant/features/chat/data/models/image_model.dart';
import 'package:ai_assistant/features/chat/domain/entities/image_entity.dart';
import 'package:ai_assistant/features/chat/domain/repositories/image_repository.dart';
import 'package:dartz/dartz.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageDataSource dataSource;

  ImageRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, String>> searchAiImage(String prompt) async {
    try {
      final result = await dataSource.searchAiImage(prompt);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<ImageEntity>>> getImages(String userId) async* {
    try {
      final stream = dataSource.getImages(userId);
      yield* stream.map(
        (imageModels) => Right(
          imageModels
              .map((model) => ImageEntity(
                    id: model.id, // Pass id
                    imageUrl: model.imageUrl,
                    prompt: model.prompt,
                    timestamp: model.timestamp,
                  ))
              .toList(),
        ),
      );
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
          id: image.id, // Pass id
          imageUrl: image.imageUrl,
          prompt: image.prompt,
          timestamp: image.timestamp,
        ),
        userId,
      );
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ServerFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  Future<Either<Failure, void>> deleteImage(
      String imageId, String userId) async {
    try {
      await dataSource.deleteImage(imageId, userId);
      return const Right(null);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message, stackTrace: e.stackTrace));
    } catch (e, stackTrace) {
      return Left(ServerFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }
}
