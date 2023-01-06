import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imager/bloc/app_bloc.dart';
import 'package:imager/bloc/app_event.dart';
import 'package:imager/bloc/app_state.dart';
import 'package:imager/dialogs/error_dialog.dart';
import 'package:imager/loading/loading_screen.dart';

import 'package:imager/services/auth/auth_service.dart';
import 'package:imager/services/database/database_service.dart';
import 'package:imager/services/media/media_service.dart';
import 'package:imager/services/storage/storage_service.dart';
import 'package:imager/views/auth/auth_view.dart';
import 'package:imager/views/main/main_view.dart';
import 'package:imager/views/image_overview/image_overview_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      primarySwatch: Colors.blue,
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme.copyWith(
        canvasColor: Colors.grey.shade300,  //is using as background color in SerachImageDialog
        backgroundColor: Colors.amber,
        colorScheme: theme.colorScheme.copyWith(secondary: Colors.amber),
      ),
      home: const App(),
      routes: {
        ImageOverviewView.route: (_) => const ImageOverviewView(),
      },
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc(
        authService: AuthService.firebase(),
        mediaService: MediaService.imagePicker(),
        storageService: StorageService.firebase(),
        databaseService: DatabaseService.firebase(),
      )..add(AppEventGoToMain()),
      child: BlocConsumer<AppBloc, AppState>(
        listener: (context, state) {
          if (state.isLoading) {
            LoadingScreen.instance().show(
              context: context,
              text: "Loading...",
            );
          } else {
            LoadingScreen.instance().hide();
          }
          if (state.exception != null) {
            showErrorDialog(context, state.exception!);
          }
        },
        builder: (context, state) {
          if (state is AppStateAuth) {
            return AuthView();
          }
          if (state is AppStateMain) {
            return const MainView();
          }
          return const Center(
            child: Text("It shouldn't happen.....or should it?"),
          );
        },
      ),
    );
  }
}
