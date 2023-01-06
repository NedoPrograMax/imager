import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:imager/models/exception/exception.dart';

@immutable
abstract class AppState {
  final bool isLoading;
  final GenericException? exception;
  const AppState({
    required this.isLoading,
    required this.exception,
  });

  factory AppState.initial() => const AppStateAuth(
        isLoading: false,
        exception: null,
      );
}

@immutable
class AppStateAuth extends AppState {
  const AppStateAuth({
    required super.isLoading,
    required super.exception,
  });
}

@immutable
class AppStateMain extends AppState {
  const AppStateMain({
    required super.isLoading,
    required super.exception,
  });


// overide is needed for correct work of BlocConsumer
  @override
  bool operator ==(other) {
    if (other is AppStateMain) {
      return isLoading == other.isLoading && exception == other.exception;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(
        isLoading,
        exception,
      );
}
