import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prexam/screens/imagesviewscreen.dart';

class ScienceListScreen extends StatelessWidget {
  final String subjectTitle;

  const ScienceListScreen({
    super.key,
    required this.subjectTitle,
  });

  @override
  Widget build(BuildContext context) {
    print('SUBJECT TITLE: "$subjectTitle"');

    final Stream<QuerySnapshot> taskStream = FirebaseFirestore.instance
        .collection('tasks')
        .where('subject', isEqualTo: subjectTitle)
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          subjectTitle,
          style: const TextStyle(
            fontFamily: 'Teacher',
            fontSize: 23,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: taskStream,
        builder: (context, snapshot) {
          print('Connection state: ${snapshot.connectionState}');
          print("Fetching tasks for: $subjectTitle");

          // 🔹 LOADING STATE
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 🔹 ERROR STATE
          if (snapshot.hasError) {
            print('Firestore error: ${snapshot.error}');
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          // 🔹 NO DATA STATE
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            print("Number of tasks: 0");
            return const Center(
              child: Text(
                'No tasks found',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          // 🔹 SAFE TO USE DATA NOW
          final tasks = snapshot.data!.docs;
          print('Tasks fetched: ${tasks.length}');
          for (var doc in tasks) {
            print('Document ID: ${doc.id} -> Data: ${doc.data()}');
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final task = tasks[index].data() as Map<String, dynamic>;

              final title = task['title'] ?? '';
              final imageUrl = task['imageUrl'] ?? '';

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  if (imageUrl.isNotEmpty) {
                    // Navigate to ImageViewScreen
                    Get.to(() => ImageViewScreen(
                          title: title,
                          imageUrl: imageUrl,
                        ));
                  } else {
                    Get.snackbar('No Image', 'This task does not have an image');
                  }
                },
                child: Container(
                  height: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.image),
                              ),
                            )
                          : Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.image, color: Colors.white),
                            ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Teacher',
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
