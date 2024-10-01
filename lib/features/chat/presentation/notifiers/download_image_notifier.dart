import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadImageNotifier extends StateNotifier<AsyncValue<void>> {
  DownloadImageNotifier() : super(const AsyncData(null));

  Future<void> downloadImage(String imageUrl, String prompt) async {
    try {
      state = const AsyncLoading();

      final status = await Permission.storage.request();
      if (!status.isGranted) {
        state = AsyncError('Permission denied', StackTrace.current);
        return;
      }

      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.bodyBytes),
          quality: 80,
          name: prompt.replaceAll(' ', '_'),
        );

        if (result['isSuccess'] == true) {
          state = const AsyncData(null);
        } else {
          throw Exception('Failed to save image');
        }
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }
}

final downloadImageNotifierProvider =
    StateNotifierProvider<DownloadImageNotifier, AsyncValue<void>>((ref) {
  return DownloadImageNotifier();
});
