import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'IFLcourse_list.dart'; // your PDF list screen

class IFLCourseScreen extends StatelessWidget {
  const IFLCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coursesCollection = FirebaseFirestore.instance.collection('courses');

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Pre-IFL Examination Course',
          style: TextStyle(
            fontFamily: 'Teacher',
            fontSize: 23,
          ),
        ),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: coursesCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No courses available',
                style: TextStyle(
                  fontFamily: 'Teacher',
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
            );
          }

          // Filter courses by courseType
          final iflCourses = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final courseType = data['courseType']?.toString().toLowerCase().trim();
            return courseType == 'pre-ifl examination'.toLowerCase();
          }).toList();

          if (iflCourses.isEmpty) {
            return const Center(
              child: Text(
                'No Pre-IFL courses available',
                style: TextStyle(
                  fontFamily: 'Teacher',
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: iflCourses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final course = iflCourses[index].data() as Map<String, dynamic>;

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // Open PDF list screen
                  Get.to(() => IFLListScreen(subjectTitle: course['title'] ?? 'Untitled'));
                },
                child: Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.menu_book,
                        size: 36,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          course['title'] ?? 'Untitled',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Teacher',
                          ),
                        ),
                      ),
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
