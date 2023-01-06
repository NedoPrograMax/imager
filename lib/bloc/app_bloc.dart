import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imager/bloc/app_event.dart';
import 'package:imager/bloc/app_state.dart';
import 'package:imager/models/image_model.dart';
import 'package:imager/services/database/database_service.dart';
import 'package:imager/utils/extensions/app_state_extensions.dart';
import 'package:imager/models/exception/exception.dart';
import 'package:imager/services/auth/auth_service.dart';
import 'package:imager/services/media/media_service.dart';
import 'package:imager/services/storage/storage_service.dart';
import 'package:uuid/uuid.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthService authService;
  final MediaService mediaService;
  final StorageService storageService;
  final DatabaseService databaseService;
  AppBloc({
    required this.authService,
    required this.mediaService,
    required this.storageService,
    required this.databaseService,
  }) : super(AppState.initial()) {
    on<AppEventLogin>(
      (event, emit) async {
        await _errorCheck(
          emit,
          state,
          isLoggedInCheck: false,
          () async {
            emit(
              const AppStateAuth(
                isLoading: true,
                exception: null,
              ),
            );
            await authService.logIn(
              email: event.email,
              password: event.password,
            );
            add(
              AppEventGoToMain(),
            );
          },
        );
      },
    );

    on<AppEventSignUp>(
      (event, emit) async {
        await _errorCheck(
          emit,
          state,
          isLoggedInCheck: false,
          () async {
            emit(
              const AppStateAuth(
                isLoading: true,
                exception: null,
              ),
            );
            await authService.signUp(
              email: event.email,
              password: event.password,
            );
            add(
              AppEventGoToMain(),
            );
          },
        );
      },
    );

    on<AppEventGoToMain>(
      (event, emit) async {
        await _errorCheck(
          emit,
          state,
          () async {
            emit(
              const AppStateMain(
                isLoading: false,
                exception: null,
              ),
            );
          },
        );
      },
    );

    on<AppEventLogOut>(
      (
        event,
        emit,
      ) async {
        await _errorCheck(
          emit,
          state,
          isLoggedInCheck: false,
          () async {
            await authService.logOut();
            emit(
              const AppStateAuth(
                isLoading: false,
                exception: null,
              ),
            );
          },
        );
      },
    );

    on<AppEventPickImage>((
      event,
      emit,
    ) async {
      final myState;
      myState = state;

      await _errorCheck(emit, state, () async {
        final image = await mediaService.pickImage();
        if (image == null) {
          return;
        }
        if (myState is AppStateMain) {
          emit(
            const AppStateMain(
              isLoading: true,
              exception: null,
            ),
          );
          final fileName = const Uuid().v4(); // generates random fileName
          final userId = authService.currentUser?.id ?? "";
          final mediumUrl = await storageService.uploadImageFromFile(
            file: image,
            name: fileName,
            userId: userId,
          );
          final newImage = ImageModel(
            userId: userId,
            fileName: fileName,
            mediumUrl: mediumUrl,
          );

          await databaseService.uploadImage(
            newImage,
            userId,
            fileName,
          );

          emit(
            const AppStateMain(
              isLoading: false,
              exception: null,
            ),
          );
        }
      });
    });

    on<AppEventDeleteImage>((event, emit) async {
      await _errorCheck(
        emit,
        state,
        () async {
          final isDeleted = await storageService.deleteImage(
            imageId: event.imageId,
            userId: event.userId,
          );
          if (isDeleted) {
            await databaseService.deleteImage(
              event.userId,
              event.imageId,
            );
          } else {
            emit(
              AppStateMain(
                isLoading: false,
                exception: GenericException(
                  title: "Delete error",
                  message: "Some error occured, image was not deleted",
                ),
              ),
            );
          }
        },
      );
    });

    on<AppEventUploadAnImageFromInternet>(
      (event, emit) async {
        await _errorCheck(
          emit,
          state,
          () async {
            emit(const AppStateMain(
              isLoading: true,
              exception: null,
            ));
            final fileName = const Uuid().v4();
            final userId = authService.currentUser?.id ?? "";
            final mediumImageUrl = await storageService.uploadImageFromBytes(
              bytes: event.imageQuality.bytes,
              name: fileName,
              userId: userId,
            );

            final newImage = ImageModel(
              mediumUrl: mediumImageUrl,
              fileName: fileName,
              userId: userId,
              originUrl: event.imageQuality.originalUrl,
            );
            databaseService.uploadImage(
              newImage,
              userId,
              fileName,
            );

            emit(
              const AppStateMain(
                isLoading: false,
                exception: null,
              ),
            );
          },
        );
      },
    );
  }

// wrappes provided code in the try catch bloc and ensures that the user is logged in(if needed)
  Future<void> _errorCheck(
    Emitter<AppState> emit,
    AppState state,
    OnEvent onEvent, {
    bool isLoggedInCheck = true,
  }) async {
    try {
      if ((isLoggedInCheck && authService.currentUser != null) ||
          !isLoggedInCheck) {
        await onEvent();
      } else {
        emit(
          AppStateAuth(
            isLoading: false,
            exception: GenericException(
              title: "Auth error",
              message: "You are not logged in",
            ),
          ),
        );
      }
    } on FirebaseException catch (e) {
      emit(
        state.transform(
          newIsLoading: false,
          newException: GenericException(
            title: e.code,
            message: e.message ?? "Firebase exception",
          ),
        ),
      );
    } catch (e) {
      emit(state.transform(
        newIsLoading: false,
        newException: GenericException(
          title: "Error",
          message: e.toString(),
        ),
      ));
    }
  }
}

// the function that should run on AppEvent's
typedef OnEvent = Future<void> Function();
