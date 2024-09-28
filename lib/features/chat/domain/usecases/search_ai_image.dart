import 'package:ai_assistant/common/errors/failures.dart';
import 'package:dartz/dartz.dart';

import '../repositories/image_repository.dart';

class SearchAiImage {
  final ImageRepository repository;

  SearchAiImage({required this.repository});

  Future<Either<Failure, String>> call(String prompt) {
    return repository.searchAiImage(prompt);
  }
}
