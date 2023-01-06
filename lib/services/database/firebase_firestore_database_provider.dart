import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:imager/models/db_image.dart';
import 'package:imager/models/image_details.dart';
import 'package:imager/models/image_model.dart';
import 'package:imager/services/database/database_provider.dart';
import 'package:imager/services/storage/storage_service.dart';

class FirebaseFirestoreDatabaseProvider implements DatabaseProvider {
  @override
  Future<void> uploadImage(
      ImageModel imageModel, String userId, String fileName) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("images")
        .doc(fileName)
        .set({
      "title": imageModel.title,
      "originUrl": imageModel.originUrl,
      "mediumUrl": imageModel.mediumUrl,
      "createdAt": Timestamp.now(),
    });
  }

  @override
  Future<void> deleteImage(String userId, String fileName) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("images")
        .doc(fileName)
        .delete();
  }

  @override
  Future<void> updateTitle(
    String userId,
    String fileName,
    String title,
  ) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("images")
        .doc(fileName)
        .update({"title": title});
  }

  @override
  Stream<List<ImageModel>> streamOfImages(String userId) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("images")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (map) => ImageModel(
                  mediumUrl: map["mediumUrl"],
                  originUrl: map["originUrl"],
                  title: map["title"],
                  fileName: map.id,
                  userId: userId,
                ),
              )
              .toList(),
        );
  }
}
