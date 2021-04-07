import 'package:flutter/material.dart';
import 'package:load_video/models/video_models.dart';
import 'package:load_video/screens/video__pick_screen.dart';
import 'package:load_video/services/video_services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final VideoServices videoServices = VideoServices();
  final TextEditingController textEditingController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool onTap = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Form(
              key: _formKey,
              child: TextFormField(
                validator: (String? value) {
                  if (value!.length < 5)
                    return "Код не может быть меньше 5 знаков";
                  else
                    return null;
                },
                controller: textEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: 'Введите код',
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
              color: Colors.white54,
              child: Text("Отправить"),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final String code = textEditingController.text;
                  print("$code");
                  final Video video = await videoServices.getVideo(code);

                  if (video.video == null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoPickScreen()));
                  }
                }
                setState(() {});
              }),
        )
      ],
    ));
  }
}
