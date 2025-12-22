import 'package:flutter/material.dart';

class LessonScreen extends StatelessWidget {
  final String lessonTitle;
  const LessonScreen({Key? key, required this.lessonTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lessonTitle),
        backgroundColor: Colors.green.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "This is the content for the lesson: $lessonTitle.\n\n"
          "Here you can add text, images, or even videos for the lesson.",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
