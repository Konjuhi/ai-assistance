import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/image_model.dart';

abstract class ImageDataSource {
  Stream<List<ImageModel>> getImages(String userId);

  Future<void> addImage(ImageModel image, String userId);

  Stream<ImageModel?> getLastImage(String userId);
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

  @override
  Stream<ImageModel?> getLastImage(String userId) {
    return firestore
        .collection('image_history')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final images = snapshot.docs.map((doc) {
          return ImageModel.fromMap(doc.data());
        }).toList();

        images.sort(
          (a, b) => b.timestamp.compareTo(a.timestamp),
        ); // Descending

        return images.isNotEmpty ? images.first : null;
      } else {
        return null;
      }
    });
  }
}
