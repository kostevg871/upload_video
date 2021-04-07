import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoPickScreen extends StatefulWidget {
  @override
  _VideoPickScreenState createState() => _VideoPickScreenState();
}

class _VideoPickScreenState extends State<VideoPickScreen> {
  late VideoPlayerController _controller;
  final _picker = ImagePicker();
  File? _video;

  Future getVideo() async {
    final pickedFile = await _picker.getVideo(source: ImageSource.gallery);
    final File video = File(pickedFile!.path);
    _controller = VideoPlayerController.file(video)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
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
          children: [
            if (_video != null)
              _controller.value.isInitialized
                  ? PickVideoPlayer(controller: _controller)
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
    Key? key,
    required VideoPlayerController controller,
  })   : _controller = controller,
        super(key: key);

  final VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}
