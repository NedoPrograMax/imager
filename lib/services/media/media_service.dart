import 'dart:io';
import 'dart:typed_data';

import 'package:imager/services/media/image_picker_provider.dart';
import 'package:imager/services/media/media_provider.dart';

class MediaService implements MediaProvider {
  final MediaProvider provider;

  const MediaService(this.provider);

  factory MediaService.imagePicker() => MediaService(ImagePickerProvider());

  @override
  Future<File?> pickImage() => provider.pickImage();
}
