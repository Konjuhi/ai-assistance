import 'package:ai_assistant/common/errors/failures.dart';
import 'package:ai_assistant/features/chat/domain/entities/image_entity.dart';
import 'package:ai_assistant/features/chat/domain/providers/domain_providers.dart';
import 'package:ai_assistant/features/chat/domain/usecases/delete_image.dart';
import 'package:ai_assistant/features/chat/domain/usecases/get_images.dart';
import 'package:ai_assistant/features/chat/presentation/providers/presentation_providers.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageListNotifier extends StateNotifier<AsyncValue<List<ImageEntity>>> {
  final GetImages getImagesUseCase;
  final DeleteImage deleteImageUseCase;
  final String userId;

  ImageListNotifier({
    required this.getImagesUseCase,
    required this.deleteImageUseCase,
    required this.userId,
  }) : super(const AsyncLoading()) {
    _loadImages();
  }

  void _loadImages() {
    if (userId.isEmpty) {
      state = const AsyncData([]);
      return;
    }

    getImagesUseCase(userId).listen(
      (Either<Failure, List<ImageEntity>> result) {
        result.fold(
          (failure) => state = AsyncError(failure.message, StackTrace.current),
          (images) {
            images.sort((a, b) => b.timestamp.compareTo(a.timestamp));
            state = AsyncData(images);
          },
        );
      },
      onError: (e, stack) {
        state = AsyncError(e.toString(), stack);
      },
    );
  }

  Future<void> deleteImage(String imageId) async {
    final currentImages = state.value ?? [];

    state =
        AsyncData(currentImages.where((image) => image.id != imageId).toList());

    final result = await deleteImageUseCase(imageId, userId);

    result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
      },
      (_) {
        _loadImages();
      },
    );
  }

  void clearState() {
    state = const AsyncData([]);
  }
}

final imageListNotifierProvider =
    StateNotifierProvider<ImageListNotifier, AsyncValue<List<ImageEntity>>>(
        (ref) {
  final userId = ref.watch(userIdProvider).maybeWhen(
        data: (uid) => uid,
        orElse: () => null,
      );

  if (userId == null) {
    return ImageListNotifier(
      getImagesUseCase: ref.watch(getImagesUseCaseProvider),
      deleteImageUseCase: ref.watch(deleteImageUseCaseProvider),
      userId: '',
    )..clearState();
  }

  return ImageListNotifier(
    getImagesUseCase: ref.watch(getImagesUseCaseProvider),
    deleteImageUseCase: ref.watch(deleteImageUseCaseProvider),
    userId: userId,
  );
});
