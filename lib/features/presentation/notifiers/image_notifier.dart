import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/failures.dart';
import '../../data/datasources/firebase_image_datasource.dart';
import '../../data/datasources/remote/image_service.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/usecases/generate_images.dart';
import '../../domain/usecases/get_images.dart';

class ImageNotifier extends StateNotifier<AsyncValue<ImageEntity?>> {
  final GenerateImage generateImageUseCase;
  final FirebaseImageDataSource imageDataSource;
  final GetImages getImagesUseCase;
  final String userId;

  ImageNotifier({
    required this.generateImageUseCase,
    required this.imageDataSource,
    required this.getImagesUseCase,
    required this.userId,
  }) : super(const AsyncLoading()) {
    _loadLastImage();
  }

  void clearState() {
    state = const AsyncData(null);
    print("State cleared, image set to null.");
  }

  void _loadLastImage() {
    if (userId.isEmpty) {
      state = const AsyncData(null);
      print("User ID is empty, no image to load.");
      return;
    }

    print("Loading last image for user: $userId");

    getImagesUseCase(userId).listen(
      (Either<Failure, List<ImageEntity>> result) {
        result.fold(
          (failure) {
            state = AsyncError(failure.message, StackTrace.current);
            print("Error loading images: ${failure.message}");
          },
          (images) {
            // Sort images by timestamp to get the most recent one
            images.sort((a, b) => b.timestamp.compareTo(a.timestamp));

            if (images.isNotEmpty) {
              print("Loaded image: ${images.first.imageUrl}");
              state = AsyncData(images.first);
            } else {
              print("No images found for user: $userId");
              state = const AsyncData(null);
            }
          },
        );
      },
      onError: (e, stack) {
        print("Error loading last image: $e");
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
          (failure) {
            state = AsyncError(failure.message, StackTrace.current);
          },
          (_) {
            state = AsyncData(image); // Update state with the new image
          },
        );
      } else {
        state = AsyncError('No images found', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}
