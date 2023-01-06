import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:imager/bloc/app_bloc.dart';
import 'package:imager/bloc/app_event.dart';
import 'package:imager/dialogs/search_image_dialog.dart';
import 'package:imager/models/image_quality.dart';

class ImageInDialog extends StatelessWidget {
  const ImageInDialog(this.image, this.onImageTap, {super.key});
  final Future<ImageQuality> image;
  final OnImageTap onImageTap;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: image,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.waiting &&
            snapshot.hasData) {
          return GestureDetector(
            onTap: () => onImageTap(snapshot.data!),
            child: Image.memory(
              snapshot.data!.bytes,
              fit: BoxFit.cover,
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
