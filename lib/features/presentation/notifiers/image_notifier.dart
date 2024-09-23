import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/errors/app_exceptions.dart';
import '../../common/errors/failures.dart';
import '../../data/datasources/remote/image_service.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/usecases/generate_images.dart';
import '../../domain/usecases/get_images.dart';

class ImageNotifier extends StateNotifier<AsyncValue<ImageEntity?>> {
  final GenerateImage generateImageUseCase;
  final GetImages getImagesUseCase;
  final String userId;

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
            images.sort((a, b) => b.timestamp.compareTo(a.timestamp));

            if (images.isNotEmpty) {
              if (kDebugMode) {
                print("Loaded image: ${images.first.imageUrl}");
              }
              state = AsyncData(images.first);
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
    if (userId.isEmpty) return;

    state = const AsyncLoading();

    try {
      final imageUrl = await ImageService.searchAiImage(prompt);
      if (imageUrl.isNotEmpty) {
        final image = ImageEntity(
          imageUrl: imageUrl,
          prompt: prompt,
          timestamp: DateTime.now(),
        );

        final Either<Failure, void> result =
            await generateImageUseCase(image, userId);

        result.fold(
          (failure) => state = AsyncError(failure.message, StackTrace.current),
          (_) => state = AsyncData(image),
        );
      } else {
        state = AsyncError('No images found', StackTrace.current);
      }
    } on AppException catch (e) {
      state = AsyncError(e.message, StackTrace.current);
    } catch (e, stack) {
      state = AsyncError(e.toString(), stack);
    }
  }
}
