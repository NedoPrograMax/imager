
import 'package:imager/models/image_model.dart';


abstract class DatabaseProvider {


  Future<void> uploadImage(
    ImageModel imageModel,
    String userId,
    String fileName,
  );

  Future<void> deleteImage(
    String userId,
    String fileName,
  );

  Future<void> updateTitle(
    String userId,
    String fileName,
    String title,
  );

  Stream<List<ImageModel>> streamOfImages(
    String userId,
  );
}
