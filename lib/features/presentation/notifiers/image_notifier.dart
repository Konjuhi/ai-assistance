// lib/presentation/notifiers/image_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/image_entity.dart';
import '../../domain/usecases/generate_images.dart';
import '../../domain/usecases/get_images.dart';

class ImageNotifier extends StateNotifier<AsyncValue<List<ImageEntity>>> {
  final GetImages getImagesUseCase;
  final GenerateImage generateImageUseCase;
  final String userId;

  ImageNotifier({
    required this.getImagesUseCase,
    required this.generateImageUseCase,
    required this.userId,
  }) : super(const AsyncLoading()) {
    _loadImages();
  }

  void _loadImages() {
    getImagesUseCase(userId).listen((images) {
      state = AsyncData(images);
    }, onError: (e, stack) {
      state = AsyncError(e, stack);
    });
  }

  Future<void> addImage(ImageEntity image) async {
    await generateImageUseCase(image, userId);
  }
}
