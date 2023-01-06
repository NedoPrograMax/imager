import 'package:flutter/foundation.dart' show Uint8List;

class ImageModel {
  // final Uint8List bytes;
  final String fileName;
  final String userId;
  final String mediumUrl;
  final String? originUrl;
  final String? title;

  ImageModel({
    //  required this.bytes,
    required this.fileName,
    required this.userId,
    required this.mediumUrl,
    this.originUrl,
    this.title,
  });
}
