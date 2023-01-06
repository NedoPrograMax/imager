import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageOverviewView extends StatelessWidget {
  const ImageOverviewView({super.key});

  static const route = "/image";
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, Object?>;
    final image = arguments["image"] as ImageProvider?;
    final smallImage = arguments["smallImage"] as ImageProvider;
    final tag = arguments["tag"];
    //at first you see Hero animation which leads you to the medium quality image
    //after HQ image is loaded, it replases the previous one
    return Scaffold(
      body: buildPhotoView(
        (p0, p1) => buildPhotoView(
          null,
          smallImage,
          tag,
        ),
        image ?? smallImage,
        tag!,
      ),
    );
  }
}

Widget buildPhotoView(LoadingBuilder builder, ImageProvider image, Object tag) {
  return PhotoView(
    heroAttributes: PhotoViewHeroAttributes(tag: tag),
    minScale: PhotoViewComputedScale.contained * 0.8,
    maxScale: PhotoViewComputedScale.covered * 1.4,
    initialScale: PhotoViewComputedScale.contained * 1.1,
    enableRotation: false,
    backgroundDecoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.black,
          Colors.grey.shade800,
          Colors.grey,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    imageProvider: image,
    loadingBuilder: builder,
  );
}

typedef LoadingBuilder = Widget Function(BuildContext, ImageChunkEvent?)?;
