import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:load_video/models/video_models.dart';

class VideoServices {
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
}
