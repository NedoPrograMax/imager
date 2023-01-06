import 'package:flutter/material.dart';
import 'package:imager/bloc/app_bloc.dart';
import 'package:imager/bloc/app_event.dart';
import 'package:imager/dialogs/edit_text_dialog.dart';
import 'package:imager/models/image_model.dart';
import 'package:imager/services/database/database_service.dart';
import 'package:imager/views/image_overview/image_overview_view.dart';
import 'package:imager/views/main/circle_buton.dart';

import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import "package:flutter_bloc/flutter_bloc.dart";

class GridImageItem extends StatefulWidget {
  const GridImageItem({required this.imageModel, super.key});
  final ImageModel imageModel;

  @override
  State<GridImageItem> createState() => _GridImageItemState();
}

class _GridImageItemState extends State<GridImageItem>
    with TickerProviderStateMixin {
  bool _isShaking = false;
  AnimationController? _controller;
  Animation<Offset>? _offsetAnimation;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 400,
      ),
    );
    _offsetAnimation = Tween(begin: const Offset(0, 1), end: const Offset(0, -0.4))
        .animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.linear,
    ));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );
    super.initState();
  }

  void toggleShaking() {
    setState(() {
      _isShaking = !_isShaking;
    });
    if (_isShaking) {
      _controller?.forward();
    } else {
      _controller?.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageModel = widget.imageModel;
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
              ImageOverviewView.route,
              arguments: {
                //two images are needed, because the second will be used as a "loading"
                "image": imageModel.originUrl != null
                    ? NetworkImage(imageModel.originUrl!)
                    : null,
                "smallImage": NetworkImage(imageModel.mediumUrl),
                //tag is needed for Hero animation
                "tag": imageModel.fileName,
              },
            ),
            onLongPress: () {
              toggleShaking();
            },
            child: Hero(
              tag: imageModel.fileName,
              child: ShakeWidget(
                duration: const Duration(milliseconds: 4000),
                shakeConstant: ShakeRotateConstant2(),
                autoPlay: _isShaking,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                  child: Image.network(
                    imageModel.mediumUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: -20,
          child: SlideTransition(
            position: _offsetAnimation!,
            child: FadeTransition(
              opacity: _opacityAnimation!,
              child: CircleButton(
                Icons.delete,
                Colors.red,
                () {
                  //the button shouldn't be active if it is not visible
                  if (_isShaking) {
                    context.read<AppBloc>().add(
                          AppEventDeleteImage(
                            imageId: imageModel.fileName,
                            userId: imageModel.userId,
                          ),
                        );
                  }
                },
              ),
            ),
          ),
        ),
        Positioned(
          right: -20,
          child: SlideTransition(
            position: _offsetAnimation!,
            child: FadeTransition(
              opacity: _opacityAnimation!,
              child: CircleButton(
                Icons.edit,
                Colors.greenAccent,
                () async {
                  //the button shouldn't be active if it is not visible
                  if (_isShaking) {
                    final newTitle = await showEditTextDialog(
                        context, imageModel.title ?? "");
                    if (newTitle != null && newTitle != imageModel.title) {
                      DatabaseService.firebase().updateTitle(
                          imageModel.userId, imageModel.fileName, newTitle);
                    }
                  }
                },
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -16,
          left: 0,
          right: 0,
          child: Text(
            imageModel.title ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
