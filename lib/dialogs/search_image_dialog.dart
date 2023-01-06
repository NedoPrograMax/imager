import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart';
import 'package:imager/bloc/app_bloc.dart';
import 'package:imager/bloc/app_event.dart';
import 'package:imager/models/image_quality.dart';
import 'package:imager/services/images/images_service.dart';
import 'package:imager/widgets/grid_image_in_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<dynamic> showSearchImageDialog(
  BuildContext providerContext,
) {
  return showDialog(
    context: providerContext,
    builder: (dialogContext) {
      Future<Iterable<Future<ImageQuality>>>? images;
      return StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Theme.of(context).canvasColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                              labelText: "Search for an image"),
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            setState(() {
                              images =
                                  ImagesService.pexels().searchForImages(value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder(
                    future: images,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        return GridImageInDialog(
                          snapshot.data!,
                          (imageQuality) {
                            Navigator.of(dialogContext).pop();
                            providerContext.read<AppBloc>().add(
                                  AppEventUploadAnImageFromInternet(imageQuality),
                                );
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

typedef OnImageTap = void Function(ImageQuality imageQuality);
