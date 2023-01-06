import 'dart:typed_data';

import 'package:imager/models/image_quality.dart';

abstract class ImagesProvider {
  Future<Iterable<Future<ImageQuality>>> searchForImages(String name);
}
