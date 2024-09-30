import 'package:ai_assistant/features/chat/domain/repositories/translation_repository.dart';

class GetLanguages {
  final TranslationRepository repository;

  GetLanguages(this.repository);

  Map<String, String> call() {
    return repository.getLanguages();
  }
}
