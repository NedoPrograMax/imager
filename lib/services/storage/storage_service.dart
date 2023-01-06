import 'dart:io';
import 'dart:typed_data';

import 'package:imager/services/storage/firebase_storage_provider.dart';
import 'package:imager/services/storage/storage_provider.dart';

import '../../models/image_details.dart';

class StorageService implements StorageProvider {
  final StorageProvider provider;

  StorageService(this.provider);
  factory StorageService.firebase() =>
      StorageService(FirebaseStorageProvider());

  @override
   Future<String> uploadImageFromFile({
    required File file,
    required String name,
    required String userId,
  }) =>
      provider.uploadImageFromFile(
        file: file,
        name: name,
        userId: userId,
      );

  @override
  Future<List<Future<StorageImage?>>> loadImages({
    required String userId,
  }) =>
      provider.loadImages(userId: userId);

  @override
  Future<bool> deleteImage({
    required String imageId,
    required String userId,
  }) =>
      provider.deleteImage(
        imageId: imageId,
        userId: userId,
      );

  @override
  Future<String> uploadImageFromBytes({
    required Uint8List bytes,
    required String name,
    required String userId,
  }) =>
      provider.uploadImageFromBytes(
        bytes: bytes,
        name: name,
        userId: userId,
      );
}
