import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:load_video/models/video_models.dart';

class VideoServices {
  Dio dio = Dio();

  Future<Video> getVideo(String code) async {
    final Uri apiUrl = Uri.parse("https://dev.gift.routeam.ru/api/$code");
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      print(response.body);
      final videoJson = jsonDecode(response.body);
      return Video.fromJson(videoJson);
    } else {
      throw Exception("${response.statusCode} err");
    }
  }

  Future<void> postVideo(File? file, String code) async {
    final Uri apiUrl = Uri.parse("https://dev.gift.routeam.ru/api");

    String filename = file!.path.split("/").last;

    FormData formData = FormData.fromMap({
      "File": await MultipartFile.fromFile(file.path, filename: filename),
      "Code": code,
      "Template": 1
    });
    Response response = await dio.post(apiUrl.toString(),
        data: formData,
        options: Options(headers: {
          "Accept": "application/json",
          "Content-Type": "multipart/form-data"
        }));

    print(response.statusCode);
    if (response.statusCode == 200) {
    } else {
      throw Exception("e");
    }
  }
}
