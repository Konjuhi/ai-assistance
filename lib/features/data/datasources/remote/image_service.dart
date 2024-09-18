import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class ImageService {
  static Future<String> searchAiImage(String prompt) async {
    try {
      final res = await http
          .get(Uri.parse('https://lexica.art/api/v1/search?q=$prompt'));

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
        return '';
      }
    } catch (e) {
      log('searchAiImage Error: $e');
      return '';
    }
  }
}
