import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

import 'package:imager/services/media/media_provider.dart';

class ImagePickerProvider implements MediaProvider {
  @override
  Future<File?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80
    );
    if(image == null) return null;
    final File file = File(image.path);
    return file;
  }
}
