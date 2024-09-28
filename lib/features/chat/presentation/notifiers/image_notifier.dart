import 'package:ai_assistant/common/common.dart';
import 'package:ai_assistant/features/chat/data/datasources/datasource.dart';
import 'package:ai_assistant/features/chat/domain/domain.dart';
import 'package:ai_assistant/features/chat/presentation/providers/presentation_providers.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageNotifier extends StateNotifier<AsyncValue<ImageEntity?>> {
  final GenerateImage generateImageUseCase;
  final GetImages getImagesUseCase;
  final String userId;
  bool _isGenerating = false;

  ImageNotifier({
    required this.generateImageUseCase,
    required this.getImagesUseCase,
    required this.userId,
  }) : super(const AsyncLoading()) {
    _loadLastImage();
  }

  void clearState() {
    state = const AsyncData(null);
    if (state is AsyncData<ImageEntity?>) {
      if (kDebugMode) {
        print("State cleared, image set to null.");
      }
    }
  }

  void _loadLastImage() {
    if (userId.isEmpty) {
      state = const AsyncData(null);
      if (kDebugMode) {
        print("User ID is empty, no image to load.");
      }
      return;
    }

    if (kDebugMode) {
      print("Loading last image for user: $userId");
    }

    getImagesUseCase(userId).listen(
      (Either<Failure, List<ImageEntity>> result) {
        result.fold(
          (failure) {
            state = AsyncError(failure.message, StackTrace.current);
            if (kDebugMode) {
              print("Error loading images: ${failure.message}");
            }
          },
          (images) {
            if (images.isNotEmpty) {
              images.sort((a, b) => b.timestamp.compareTo(a.timestamp));
              final latestImage = images.first;

              if (state is! AsyncData ||
                  (state as AsyncData).value != latestImage) {
                if (kDebugMode) {
                  print("Loaded image: ${latestImage.imageUrl}");
                }
                state = AsyncData(latestImage);
              }
            } else {
              if (kDebugMode) {
                print("No images found for user: $userId");
              }
              state = const AsyncData(null);
            }
          },
        );
      },
      onError: (e, stack) {
        if (kDebugMode) {
          print("Error loading last image: $e");
        }
        state = AsyncError(e, stack);
      },
    );
  }

  Future<void> generateImage(String prompt) async {
    if (userId.isEmpty || _isGenerating) return;

    _isGenerating = true;
    if (kDebugMode) {
      print('Start generating image for prompt: $prompt');
    }

    state = const AsyncLoading();

    try {
      final imageUrl = await ImageService.searchAiImage(prompt);
      if (kDebugMode) {
        print('Image URL generated: $imageUrl');
      }

      if (imageUrl.isNotEmpty) {
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
            if (kDebugMode) {
              print('Error saving image: ${failure.message}');
            }
            state = AsyncError(failure.message, StackTrace.current);
          },
          (_) {
            if (kDebugMode) {
              print('Image successfully saved to state');
            }
            state = AsyncData(image);
          },
        );
      } else {
        if (kDebugMode) {
          print('No images found');
        }
        state = AsyncError('No images found', StackTrace.current);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error generating image: $e');
      }
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
      userId: '',
    )..clearState();
  }

  return ImageNotifier(
    generateImageUseCase: ref.watch(generateImageUseCaseProvider),
    getImagesUseCase: ref.watch(getImagesUseCaseProvider),
    userId: userId,
  );
});
