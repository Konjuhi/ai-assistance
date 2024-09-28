import 'package:ai_assistant/common/errors/failures.dart';
import 'package:dartz/dartz.dart';

import '../repositories/chat_repository.dart';

class GetAIResponse {
  final ChatRepository repository;

  GetAIResponse(this.repository);

  Future<Either<Failure, String>> call(String question) {
    return repository.getAIResponse(question);
  }
}
