import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prexam/screens/sociallist.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  final List<Map<String, dynamic>> socialTasks = const [
    {'icon': Icons.nature_people, 'title': 'Morality'},
    {'icon': Icons.landscape, 'title': 'Geography'},
    {'icon': Icons.calculate, 'title': 'Mathematics'},
    {'icon': Icons.public, 'title': 'Earth Science'},
    {'icon': Icons.book, 'title': 'Khmer Literature'},
    {'icon': Icons.map_sharp, 'title': 'Historial'},
    //{'icon': Icons.my_library_books, 'title': 'English Literature'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF48F8F),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Social Task',
          style: TextStyle(
            fontFamily: 'Teacher',
            fontSize: 23,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: socialTasks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final task = socialTasks[index];

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Get.to(
                  () => SocialListScreen(
                    subjectTitle: task['title'],
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDB2B2),
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
                      color: const Color(0xFFD56262),
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
            ),
          );
        },
      ),
    );
  }
}
