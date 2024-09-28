import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/translation_entity.dart';
import '../../domain/providers/domain_providers.dart';
import '../../domain/usecases/translate_text.dart';
import '../providers/presentation_providers.dart';

class TranslateNotifier extends StateNotifier<AsyncValue<TranslationEntity?>> {
  final TranslateText translateUseCase;
  final String userId;

  String? fromLanguage;
  String? toLanguage;
  String textToTranslate = '';

  TranslateNotifier({
    required this.translateUseCase,
    required this.userId,
  }) : super(const AsyncData(null));

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
        state = AsyncData(translation);
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

  void clearState() {
    state = const AsyncData(null);
    fromLanguage = null;
    toLanguage = null;
    textToTranslate = '';
  }
}

final translateNotifierProvider =
    StateNotifierProvider<TranslateNotifier, AsyncValue<TranslationEntity?>>(
        (ref) {
  final userId = ref.watch(userIdProvider).maybeWhen(
        data: (uid) => uid,
        orElse: () => null,
      );

  if (userId == null) {
    return TranslateNotifier(
        translateUseCase: ref.watch(translateTextUseCaseProvider), userId: '');
  }

  return TranslateNotifier(
    translateUseCase: ref.watch(translateTextUseCaseProvider),
    userId: userId,
  );
});
