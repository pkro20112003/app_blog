import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class UploadPicture {
  Future<dynamic> UploadImage(
    Uint8List bytes,
    String filename,
  ) async {
    Uri url = Uri.parse("https://api.escuelajs.co/api/v1/files/upload");
    var request = http.MultipartRequest("POST", url);
    var myfile = http.MultipartFile(
      "file",
      http.ByteStream.fromBytes(bytes),
      bytes.length,
      filename: filename,
    );
    request.files.add(myfile);
    final response = await request.send();
    if (response.statusCode == 201) {
      var data = await response.stream.bytesToString();
      return jsonDecode(data);
    } else {
      return null;
    }
  }
}
