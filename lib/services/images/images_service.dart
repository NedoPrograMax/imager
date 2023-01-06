import 'dart:typed_data';

import 'package:imager/models/image_quality.dart';
import 'package:imager/services/images/images_provider.dart';
import 'package:imager/services/images/pexels_images_provider.dart';

class ImagesService implements ImagesProvider {
  final ImagesProvider provider;

  ImagesService(this.provider);

  factory ImagesService.pexels() => ImagesService(PexelsImagesProvider());

  @override
  Future<Iterable<Future<ImageQuality>>> searchForImages(String name) =>
      provider.searchForImages(name);
}
