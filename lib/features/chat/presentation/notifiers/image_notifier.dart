import 'package:ai_assistant/common/errors/failures.dart';
import 'package:ai_assistant/features/chat/domain/domain.dart';
import 'package:ai_assistant/features/chat/domain/usecases/search_ai_image.dart';
import 'package:ai_assistant/features/chat/presentation/providers/presentation_providers.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageNotifier extends StateNotifier<AsyncValue<ImageEntity?>> {
  final GenerateImage generateImageUseCase;
  final GetImages getImagesUseCase;
  final SearchAiImage searchAiImageUseCase;
  final String userId;
  bool _isGenerating = false;

  ImageNotifier({
    required this.generateImageUseCase,
    required this.getImagesUseCase,
    required this.searchAiImageUseCase,
    required this.userId,
  }) : super(const AsyncLoading()) {
    _loadLastImage();
  }

  void clearState() {
    state = const AsyncData(null);
  }

  void _loadLastImage() {
    if (userId.isEmpty) {
      state = const AsyncData(null);
      return;
    }

    getImagesUseCase(userId).listen(
      (Either<Failure, List<ImageEntity>> result) {
        result.fold(
          (failure) {
            state = AsyncError(failure.message, StackTrace.current);
          },
          (images) {
            if (images.isNotEmpty) {
              images.sort((a, b) => b.timestamp.compareTo(a.timestamp));
              final latestImage = images.first;

              if (state is! AsyncData ||
                  (state as AsyncData).value != latestImage) {
                state = AsyncData(latestImage);
              }
            } else {
              state = const AsyncData(null);
            }
          },
        );
      },
      onError: (e, stack) {
        state = AsyncError(e, stack);
      },
    );
  }

  Future<void> generateImage(String prompt) async {
    if (userId.isEmpty || _isGenerating) return;

    _isGenerating = true;
    state = const AsyncLoading();

    try {
      final response = await searchAiImageUseCase.call(prompt);
      response.fold(
        (failure) {
          state = AsyncError(failure.message, StackTrace.current);
        },
        (imageUrl) async {
          final image = ImageEntity(
            id: '',
            imageUrl: imageUrl,
            prompt: prompt,
            timestamp: DateTime.now(),
          );

          final Either<Failure, void> result =
              await generateImageUseCase(image, userId);

          result.fold(
            (failure) {
              state = AsyncError(failure.message, StackTrace.current);
            },
            (_) {
              state = AsyncData(image);
            },
          );
        },
      );
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    } finally {
      _isGenerating = false;
    }
  }
}

final imageNotifierProvider =
    StateNotifierProvider<ImageNotifier, AsyncValue<ImageEntity?>>((ref) {
  final userId = ref.watch(userIdProvider).maybeWhen(
        data: (uid) => uid,
        orElse: () => null,
      );

  if (userId == null) {
    return ImageNotifier(
      generateImageUseCase: ref.watch(generateImageUseCaseProvider),
      getImagesUseCase: ref.watch(getImagesUseCaseProvider),
      searchAiImageUseCase: ref.watch(searchAiImageUseCaseProvider),
      userId: '',
    )..clearState();
  }

  return ImageNotifier(
    generateImageUseCase: ref.watch(generateImageUseCaseProvider),
    getImagesUseCase: ref.watch(getImagesUseCaseProvider),
    searchAiImageUseCase: ref.watch(searchAiImageUseCaseProvider),
    userId: userId,
  );
});
