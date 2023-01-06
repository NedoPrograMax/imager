import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:imager/models/image_quality.dart';
import 'package:imager/services/images/images_provider.dart';
import 'package:http/http.dart' as http;
import "package:imager/secrets.dart";

class PexelsImagesProvider implements ImagesProvider {
 
  @override
  Future<Iterable<Future<ImageQuality>>> searchForImages(String name) async {
    const searchEndpoint = "https://api.pexels.com/v1/search";
    final uri = Uri.parse("$searchEndpoint?query=$name");
    final response = await http.get(
      uri,
      headers: {"Authorization": "$pexels_api_key"},
    );
    if (response.statusCode <= 400) {
      final data = json.decode(response.body);
      final photos = data["photos"] as List<dynamic>;

      final list = photos.map((element) async {
        final uri = element["src"]["medium"];
        final originalUrl = element["src"]["original"];

        final response = await http.get(Uri.parse(uri));
        return ImageQuality(
          bytes: response.bodyBytes,
          originalUrl: originalUrl,
        );
      });

      return list;
    }
    return [];
  }
}
