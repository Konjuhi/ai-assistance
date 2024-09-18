// lib/domain/repositories/image_repository.dart
import '../entities/image_entity.dart';

abstract class ImageRepository {
  Stream<List<ImageEntity>> getImages(String userId);
  Future<void> addImage(ImageEntity image, String userId);
}
