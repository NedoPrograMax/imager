import 'dart:io';
import 'dart:typed_data';

import 'package:imager/models/image_details.dart';

import 'storage_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageProvider implements StorageProvider {
  @override
  Future<String> uploadImageFromFile({
    required File file,
    required String name,
    required String userId,
  }) async {
    final storeRef = FirebaseStorage.instance.ref(userId).child(name);
    await storeRef.putFile(file);

    return await storeRef.getDownloadURL();
  }

  @override
  Future<String> uploadImageFromBytes({
    required Uint8List bytes,
    required String name,
    required String userId,
  }) async {
    final storeRef = FirebaseStorage.instance.ref(userId).child(name);
    await storeRef.putData(bytes);

    return await storeRef.getDownloadURL();
  }

  @override
  Future<List<Future<StorageImage?>>> loadImages(
      {required String userId}) async {
    final refList = await FirebaseStorage.instance.ref(userId).listAll();
    final list = refList.items.map((reference) async {
      final name = reference.name;
      final data = await reference.getData();
      return StorageImage(bytes: data!, fileName: name, userId: userId);
    });
    return [...list];
  }

  @override
  Future<bool> deleteImage({required String imageId, required userId}) {
    return FirebaseStorage.instance
        .ref(userId)
        .child(imageId)
        .delete()
        .then((value) => true)
        .catchError((_) => false);
  }
}
