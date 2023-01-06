import 'package:imager/models/db_image.dart';
import 'package:imager/models/image_model.dart';
import 'package:imager/services/database/database_provider.dart';
import 'package:imager/services/database/firebase_firestore_database_provider.dart';
import 'package:imager/services/storage/storage_service.dart';

class DatabaseService implements DatabaseProvider {
  final DatabaseProvider provider;
  DatabaseService(this.provider);
  factory DatabaseService.firebase() =>
      DatabaseService(FirebaseFirestoreDatabaseProvider());

 

  @override
  Future uploadImage( ImageModel imageModel, String userId, String fileName) =>
      provider.uploadImage(
        imageModel,
        userId,
        fileName,
      );

  @override
  Future<void> deleteImage(
    String userId,
    String fileName,
  ) =>
      provider.deleteImage(
        userId,
        fileName,
      );

  @override
  Future<void> updateTitle(
    String userId,
    String fileName,
    String title,
  ) =>
      provider.updateTitle(
        userId,
        fileName,
        title,
      );

  @override
  Stream<List<ImageModel>> streamOfImages(
    String userId,
  ) =>
      provider.streamOfImages(
        userId,
      );
}
