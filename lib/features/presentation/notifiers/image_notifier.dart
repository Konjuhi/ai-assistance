import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/firebase_image_datasource.dart';
import '../../data/datasources/remote/image_service.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/usecases/generate_images.dart';

class ImageNotifier extends StateNotifier<AsyncValue<ImageEntity?>> {
  final GenerateImage generateImageUseCase;
  final FirebaseImageDataSource imageDataSource;
  final String userId;

  ImageNotifier({
    required this.generateImageUseCase,
    required this.imageDataSource,
    required this.userId,
  }) : super(const AsyncLoading()) {
    _loadLastImage();
  }

  void _loadLastImage() {
    imageDataSource.getLastImage(userId).listen((image) {
      if (image != null) {
        state = AsyncData(image);
      } else {
        state = const AsyncData(null);
      }
    }, onError: (e) {
      state = AsyncError(e, StackTrace.current);
    });
  }

  Future<void> generateImage(String prompt) async {
    state = const AsyncLoading();

    try {
      final imageUrl = await ImageService.searchAiImage(prompt);

      if (imageUrl.isNotEmpty) {
        final image = ImageEntity(
          imageUrl: imageUrl,
          prompt: prompt,
          timestamp: DateTime.now(),
        );

        await generateImageUseCase(image, userId);

        state = AsyncData(image);
      } else {
        state = AsyncError(Exception('No images found'), StackTrace.current);
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
