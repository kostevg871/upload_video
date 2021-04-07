import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:load_video/models/video_models.dart';
import 'package:load_video/screens/video_player_screen.dart';
import 'package:load_video/services/video_services.dart';
import 'package:video_player/video_player.dart';

class VideoPickScreen extends StatefulWidget {
  String _code;
  VideoPickScreen(this._code);

  @override
  _VideoPickScreenState createState() => _VideoPickScreenState();
}

class _VideoPickScreenState extends State<VideoPickScreen> {
  VideoServices videoServices = VideoServices();
  late VideoPlayerController _controller;
  final _picker = ImagePicker();
  File? _video;

  Future getVideo() async {
    final pickedFile = await _picker.getVideo(source: ImageSource.gallery);
    final File video = File(pickedFile!.path);
    _controller = VideoPlayerController.file(video)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.setLooping(true);
    _controller.play();
    setState(() {
      _video = video;
      String path = _video!.path.split("/").last;
      print(path);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_video != null)
              _controller.value.isInitialized
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PickVideoPlayer(controller: _controller),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MaterialButton(
                                  color: Colors.blue,
                                  child: Text("Отправить"),
                                  onPressed: () async {
                                    await videoServices.postVideo(
                                        _video, widget._code);
                                    final Video new_video = await videoServices
                                        .getVideo(widget._code);
                                    if (new_video.video != null) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VideoPlayerScreen(
                                                    widget._code,
                                                    new_video.video,
                                                  )));
                                    }
                                  }),
                              SizedBox(
                                width: 10,
                              ),
                              MaterialButton(
                                  color: Colors.white24,
                                  child: Icon(_controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow),
                                  onPressed: () {
                                    setState(() {
                                      if (_controller.value.isPlaying) {
                                        _controller.pause();
                                      } else {
                                        _controller.play();
                                      }
                                    });
                                  }),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container()
            else
              Center(child: Text("Выберете видео")),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getVideo,
        tooltip: "Загрузить видео",
        child: Icon(Icons.add),
      ),
    );
  }
}

class PickVideoPlayer extends StatelessWidget {
  const PickVideoPlayer({
    required VideoPlayerController controller,
  }) : _controller = controller;

  final VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}
