import 'dart:io';

import 'package:flutter/foundation.dart' show Uint8List;

class StorageImage {
  final Uint8List bytes;
  final String fileName;
  final String userId;
 // final String? originUrl;

  StorageImage({
    required this.bytes,
    required this.fileName,
    required this.userId,
    //this.originUrl,
  });
}
