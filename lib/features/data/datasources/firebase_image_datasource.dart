// lib/data/datasources/firebase_image_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/image_model.dart';

abstract class ImageDataSource {
  Stream<List<ImageModel>> getImages(String userId);
  Future<void> addImage(ImageModel image, String userId);
}

class FirebaseImageDataSource implements ImageDataSource {
  final FirebaseFirestore firestore;

  FirebaseImageDataSource(this.firestore);

  @override
  Stream<List<ImageModel>> getImages(String userId) {
    return firestore
        .collection('image_history')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final images = snapshot.docs.map((doc) {
        return ImageModel.fromMap(doc.data());
      }).toList();

      return images;
    });
  }

  @override
  Future<void> addImage(ImageModel image, String userId) async {
    await firestore.collection('image_history').add({
      'userId': userId,
      ...image.toMap(),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
