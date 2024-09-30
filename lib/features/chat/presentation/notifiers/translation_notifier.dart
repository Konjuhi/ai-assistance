import 'package:ai_assistant/features/chat/domain/entities/translation_entity.dart';
import 'package:ai_assistant/features/chat/domain/providers/domain_providers.dart';
import 'package:ai_assistant/features/chat/domain/usecases/get_language.dart';
import 'package:ai_assistant/features/chat/domain/usecases/translate_text.dart';
import 'package:ai_assistant/features/chat/presentation/providers/presentation_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TranslateNotifier
    extends StateNotifier<AsyncValue<List<TranslationEntity>>> {
  final TranslateText translateUseCase;

  final GetLanguages getLanguagesUseCase;
  final String userId;

  TranslateNotifier({
    required this.translateUseCase,
    required this.getLanguagesUseCase,
    required this.userId,
  }) : super(const AsyncData([]));

  String? fromLanguage;
  String? toLanguage;
  String textToTranslate = '';

  Future<void> translate() async {
    if (fromLanguage == null || toLanguage == null || textToTranslate.isEmpty) {
      return;
    }

    state = const AsyncLoading();
    final result = await translateUseCase.call(
        fromLanguage!, toLanguage!, textToTranslate);
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (translation) {
        final currentState = state.value ?? [];
        state = AsyncData([...currentState, translation]);
        translateUseCase.saveTranslation(userId, translation);
      },
    );
  }

  void updateFromLanguage(String from) {
    fromLanguage = from;
  }

  void updateToLanguage(String to) {
    toLanguage = to;
  }

  void updateTextToTranslate(String text) {
    textToTranslate = text;
  }

  Map<String, String> getAvailableLanguages() {
    return getLanguagesUseCase.call();
  }

  void clearTranslationState() {
    state = const AsyncData([]);
    fromLanguage = null;
    toLanguage = null;
    textToTranslate = '';
  }
}

final translateNotifierProvider = StateNotifierProvider<TranslateNotifier,
    AsyncValue<List<TranslationEntity>>>((ref) {
  final userId = ref.watch(userIdProvider).maybeWhen(
        data: (uid) => uid,
        orElse: () => null,
      );

  return TranslateNotifier(
    translateUseCase: ref.watch(translateTextUseCaseProvider),
    getLanguagesUseCase: ref.watch(getLanguagesUseCaseProvider),
    userId: userId ?? '',
  );
});
