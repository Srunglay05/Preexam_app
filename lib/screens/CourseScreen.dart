import 'package:flutter/material.dart';

class CourseScreen extends StatelessWidget {
  final String courseName;

  const CourseScreen({Key? key, required this.courseName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    final lessons = List.generate(5, (index) => "Lesson ${index + 1}: Topic ${index + 1}");

    return Scaffold(
      appBar: AppBar(
        title: Text(courseName),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Title
            Text(
              courseName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Progress Bar Example
            const Text(
              "Progress",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.3, // Example progress
              minHeight: 10,
              backgroundColor: Colors.grey.shade300,
              color: Colors.blue.shade400,
            ),
            const SizedBox(height: 24),

            // Lessons List
            const Text(
              "Lessons",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade400,
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(lessons[index]),
                      trailing: const Icon(Icons.play_circle_outline),
                      onTap: () {
                        // Here you can navigate to lesson detail or video
                      },
                    ),
                  );
                },
              ),
            ),

            // Start Course Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Start course action
                },
                child: const Text(
                  "Start Course",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
