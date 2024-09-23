import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/errors/app_exceptions.dart';
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
    try {
      return firestore
          .collection('image_history')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return ImageModel.fromMap(doc.data());
        }).toList();
      });
    } catch (e, stackTrace) {
      throw ServerException(
          message: 'Error fetching images', stackTrace: stackTrace);
    }
  }

  @override
  Future<void> addImage(ImageModel image, String userId) async {
    try {
      await firestore.collection('image_history').add({
        'userId': userId,
        ...image.toMap(),
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e, stackTrace) {
      throw ServerException(
          message: 'Error adding image', stackTrace: stackTrace);
    }
  }

  @override
  Stream<ImageModel?> getLastImage(String userId) {
    try {
      return firestore
          .collection('image_history')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final images = snapshot.docs.map((doc) {
            return ImageModel.fromMap(doc.data());
          }).toList();
          images
              .sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Descending
          return images.isNotEmpty ? images.first : null;
        } else {
          return null;
        }
      });
    } catch (e, stackTrace) {
      throw ServerException(
          message: 'Error fetching last image', stackTrace: stackTrace);
    }
  }
}
