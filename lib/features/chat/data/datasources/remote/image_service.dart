import 'dart:convert';
import 'dart:developer';

import 'package:ai_assistant/common/errors/app_exceptions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ImageService {
  static Future<String> searchAiImage(String prompt) async {
    try {
      final accessKey = dotenv.env['UNSPLASH_ACCESS_KEY'];
      if (accessKey == null) {
        throw Exception('Unsplash access key not found');
      }
      final res = await http.get(
        Uri.parse(
            'https://api.unsplash.com/search/photos?query=$prompt&client_id=$accessKey'),
      );

      if (res.statusCode != 200) {
        throw ServerException(message: 'Error fetching images from Unsplash');
      }

      final data = jsonDecode(res.body);
      List images = data['results'];

      if (images.isNotEmpty) {
        String imageUrl = images[0]['urls']['regular'];
        log('Fetched image from Unsplash: $imageUrl');
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
