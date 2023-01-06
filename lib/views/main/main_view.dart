import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imager/bloc/app_bloc.dart';
import 'package:imager/bloc/app_event.dart';
import 'package:imager/dialogs/search_image_dialog.dart';
import 'package:imager/models/image_model.dart';
import 'package:imager/services/auth/auth_service.dart';
import 'package:imager/services/database/database_service.dart';
import 'package:imager/views/main/images_grid.dart';

import '../../models/image_details.dart';

class MainView extends StatelessWidget {
  const MainView(
      {
  
      super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        title: const Text("Imager"),
        actions: [
          IconButton(
            onPressed: () => context.read<AppBloc>().add(AppEventLogOut()),
            icon: const Icon(Icons.exit_to_app),
          ),
          IconButton(
            onPressed: () => context.read<AppBloc>().add(AppEventPickImage()),
            icon: const Icon(Icons.image),
          ),
          IconButton(
            onPressed: () => showSearchImageDialog(context),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Colors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: StreamBuilder(
            stream: DatabaseService.firebase().streamOfImages(
              AuthService.firebase().currentUser?.id ?? "",
            ),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child:  CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return ImagesGrid(
                  images: snapshot.data!,
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
