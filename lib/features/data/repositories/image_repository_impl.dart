// lib/data/repositories/image_repository_impl.dart

import '../../domain/entities/image_entity.dart';
import '../../domain/repositories/image_repository.dart';
import '../datasources/firebase_image_datasource.dart';
import '../models/image_model.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageDataSource dataSource;

  ImageRepositoryImpl(this.dataSource);

  @override
  Stream<List<ImageEntity>> getImages(String userId) {
    return dataSource.getImages(userId);
  }

  @override
  Future<void> addImage(ImageEntity image, String userId) {
    return dataSource.addImage(
      ImageModel(
        imageUrl: image.imageUrl,
        prompt: image.prompt,
        timestamp: image.timestamp,
      ),
      userId,
    );
  }
}
