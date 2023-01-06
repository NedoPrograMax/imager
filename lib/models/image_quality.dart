import 'package:flutter/foundation.dart' show Uint8List;

class ImageQuality {
  final Uint8List bytes;
  final String originalUrl;

  ImageQuality({
    required this.bytes,
    required this.originalUrl,
  });
}
