import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imager/dialogs/search_image_dialog.dart';
import 'package:imager/models/image_quality.dart';

import 'image_in_dialog.dart';

class GridImageInDialog extends StatelessWidget {
  const GridImageInDialog(this.images, this.onImageTap, {super.key});
  final Iterable<Future<ImageQuality>> images;
  final OnImageTap onImageTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: images.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) => ImageInDialog(
          images.elementAt(index),
          onImageTap,
          key: ValueKey(index),
        ),
      ),
    );
  }
}
