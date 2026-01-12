import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prexam/screens/tasks/science/sciencelist.dart';

class ScienceScreen extends StatelessWidget {
  const ScienceScreen({super.key});

  final List<Map<String, dynamic>> scienceTasks = const [
    {'icon': Icons.science, 'title': 'Physics'},
    {'icon': Icons.biotech, 'title': 'Biological'},
    {'icon': Icons.calculate, 'title': 'Mathematics'},
    {'icon': Icons.science_outlined, 'title': 'Chemistry'},
    {'icon': Icons.book, 'title': 'Khmer Literature'},
    {'icon': Icons.map_outlined, 'title': 'Historial'},
    //{'icon': Icons.my_library_books, 'title': 'English Literature'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Science Task',
          style: TextStyle(
            fontFamily: 'Teacher',
            fontSize: 23,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: scienceTasks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final task = scienceTasks[index];

          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // ✅ NAVIGATE WITH SUBJECT NAME
              Get.to(
                () => ScienceListScreen(
                  subjectTitle: task['title'],
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 70,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    task['icon'],
                    size: 36,
                    color: Colors.blue[800],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Center(
                      child: Text(
                        task['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Teacher',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
