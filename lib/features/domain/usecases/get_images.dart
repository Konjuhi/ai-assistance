import '../entities/image_entity.dart';
import '../repositories/image_repository.dart';

class GetImages {
  final ImageRepository repository;

  GetImages(this.repository);

  Stream<List<ImageEntity>> call(String userId) {
    return repository.getImages(userId);
  }
}
