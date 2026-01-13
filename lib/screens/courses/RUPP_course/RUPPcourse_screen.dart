import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prexam/screens/courses/RUPP_course/RUPPcourse_list.dart';
// import the next screen if you have one
// import 'package:prexam/screens/tasks/doctor/doctorlist.dart';

class RUPPCourseScreen extends StatelessWidget {
  const RUPPCourseScreen({super.key});

  final List<Map<String, dynamic>> ruppCourses = const [
    {'icon': Icons.science, 'title': 'Physics'},
    {'icon': Icons.calculate, 'title': 'Mathematics'},
    {'icon': Icons.science_outlined, 'title': 'Chemistry'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// 🟦 APP BAR
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Pre-Doctor Examination Course',
          style: TextStyle(
            fontFamily: 'Teacher',
            fontSize: 23,
          ),
        ),
        centerTitle: true,
      ),

      /// 📋 COURSE LIST
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: ruppCourses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final course = ruppCourses[index];

          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // 🔁 Navigate to next screen if needed
              Get.to(() => RUPPListScreen(subjectTitle: course['title']));
              debugPrint("Selected: ${course['title']}");
            },
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.orange[100],
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
                    course['icon'],
                    size: 36,
                    color: Colors.orange[800],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Center(
                      child: Text(
                        course['title'],
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
