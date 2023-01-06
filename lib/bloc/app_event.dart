import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show immutable;

import 'package:imager/models/image_quality.dart';

@immutable
abstract class AppEvent {
  const AppEvent();
}

@immutable
class AppEventLogin implements AppEvent {
  final String email;
  final String password;

  const AppEventLogin({required this.email, required this.password});
}

@immutable
class AppEventSignUp implements AppEvent {
  final String email;
  final String password;

  const AppEventSignUp({required this.email, required this.password});
}

@immutable
class AppEventGoToMain implements AppEvent {}

@immutable
class AppEventLogOut implements AppEvent {}

@immutable
class AppEventPickImage implements AppEvent {}

@immutable
class AppEventDeleteImage implements AppEvent {
  final String imageId;
  final String userId;
  const AppEventDeleteImage({
    required this.imageId,
    required this.userId,
  });
}

@immutable
class AppEventUploadAnImageFromInternet implements AppEvent {
  final ImageQuality imageQuality;

  const AppEventUploadAnImageFromInternet(this.imageQuality);
}

