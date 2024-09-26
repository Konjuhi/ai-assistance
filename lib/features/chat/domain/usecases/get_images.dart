import 'package:ai_assistant/common/common.dart';
import 'package:ai_assistant/features/chat/domain/domain.dart';
import 'package:dartz/dartz.dart';

class GetImages {
  final ImageRepository repository;

  GetImages(this.repository);

  Stream<Either<Failure, List<ImageEntity>>> call(String userId) {
    return repository.getImages(userId);
  }
}
