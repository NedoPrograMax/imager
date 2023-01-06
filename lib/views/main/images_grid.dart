import 'package:flutter/material.dart';
import 'package:imager/models/image_model.dart';
import 'package:imager/views/main/grid_image_item.dart';


class ImagesGrid extends StatelessWidget {
  const ImagesGrid({
    required this.images,
    super.key,
  });
  final List<ImageModel> images;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 18,
      ),
      itemBuilder: (context, index) => GridImageItem(
        imageModel: images[index],
        key: ValueKey(
          images[index].fileName,
        ),
      ),
      itemCount: images.length,
    );
  }
}
