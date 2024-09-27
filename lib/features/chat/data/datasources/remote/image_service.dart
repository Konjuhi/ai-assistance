import 'dart:convert';
import 'dart:developer';

import 'package:ai_assistant/common/errors/app_exceptions.dart';
import 'package:http/http.dart' as http;

class ImageService {
  static Future<String> searchAiImage(String prompt) async {
    try {
      final res = await http
          .get(Uri.parse('https://lexica.art/api/v1/search?q=$prompt'));

      if (res.statusCode != 200) {
        throw ServerException(message: 'Error fetching images');
      }

      final data = jsonDecode(res.body);
      List images = data['images'];

      if (images.isNotEmpty) {
        String imageUrl = images[0]['src'].toString();
        log('Fetched image from API: $imageUrl');
        return imageUrl;
      } else {
        throw ServerException(message: 'No images found');
      }
    } catch (e, stackTrace) {
      log('searchAiImage Error: $e');
      throw ServerException(
          message: 'Error fetching images', stackTrace: stackTrace);
    }
  }
}
