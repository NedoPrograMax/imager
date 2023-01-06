import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../models/image_details.dart';

abstract class StorageProvider {
  Future<String> uploadImageFromFile({
    required File file,
    required String name,
    required String userId,
  });

  Future<String> uploadImageFromBytes({
    required Uint8List bytes,
    required String name,
    required String userId,
  });

  Future<List<Future<StorageImage?>>> loadImages({
    required String userId,
  });

  Future<bool> deleteImage({
    required String imageId,
    required String userId,
  });
}
