import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;

extension GetImageFromUrl on String {
  Future<Uint8List> getImage() async {
    final url = Uri.parse(this);
    final response = await http.get(url);
    return response.bodyBytes;
  }
}
