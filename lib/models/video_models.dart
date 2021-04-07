import 'dart:convert';

Video videoFromJson(String str) => Video.fromJson(json.decode(str));

String videoToJson(Video data) => json.encode(data.toJson());

class Video {
  Video({
    this.video,
    required this.code,
    this.template,
  });

  dynamic video;
  String code;
  dynamic template;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        video: json["video"],
        code: json["code"],
        template: json["template"],
      );

  Map<String, dynamic> toJson() => {
        "video": video,
        "code": code,
        "template": template,
      };
}
