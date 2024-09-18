// lib/domain/usecases/image/generate_image.dart
import '../entities/image_entity.dart';
import '../repositories/image_repository.dart';

class GenerateImage {
  final ImageRepository repository;

  GenerateImage(this.repository);

  Future<void> call(ImageEntity image, String userId) {
    return repository.addImage(image, userId);
  }
}
