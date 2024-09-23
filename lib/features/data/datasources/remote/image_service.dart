import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../../../common/errors/app_exceptions.dart';

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
        final String userId = FirebaseAuth.instance.currentUser!.uid;

        await FirebaseFirestore.instance.collection('image_history').add({
          'userId': userId,
          'prompt': prompt,
          'imageUrl': imageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        return imageUrl;
      } else {
        throw ServerException(message: 'No images found');
      }
    } catch (e, stackTrace) {
      log('searchAiImage Error: $e');
      if (e is FirebaseAuthException) {
        throw ServerException(
            message: 'Authentication error', stackTrace: stackTrace);
      }
      if (e is FirebaseException) {
        throw NetworkException(
            message: 'Network error', stackTrace: stackTrace);
      }
      throw UnknownException(message: 'Unknown error occurred');
    }
  }
}
