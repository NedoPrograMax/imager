import 'dart:io';



abstract class MediaProvider {
  Future<File?> pickImage();
}
