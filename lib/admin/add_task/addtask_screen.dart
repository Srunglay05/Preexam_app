import 'package:flutter/material.dart';
import 'package:prexam/admin/add_task/addtask_dialog.dart';
import 'package:prexam/admin/add_task/categoriescard.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  bool showScience = false;
  bool showSocial = false;

  final List<String> scienceSubjects = [
    'Physics',
    'Chemistry',
    'Biology',
    'Mathematics',
    'History',
    'Khmer Literature',
  ];

  final List<String> socialSubjects = [
    'History',
    'Geography',
    'Morality',
    'Earth Science',
    'Mathematics',
    'Khmer Literature',
  ];

  void onSubjectSelected(String category, String subject) {
    showAddTaskDialog(
      context: context,
      category: category,
      subject: subject,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 🔵 BLUE APP BAR
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Add Task',
          style: TextStyle(
            fontFamily: 'Teacher',
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),

      /// 🌈 GRADIENT BACKGROUND
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F7FB), // soft light
              Color(0xFF2196F3), // blue
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// SCIENCE CATEGORY
              CategoryCard(
                title: 'Science',
                icon: Icons.science,
                isExpanded: showScience,
                onTap: () {
                  setState(() {
                    showScience = !showScience;
                    showSocial = false;
                  });
                },
                subjects: scienceSubjects,
                onSubjectTap: (subject) =>
                    onSubjectSelected('Science', subject),
              ),

              const SizedBox(height: 16),

              /// SOCIAL CATEGORY
              CategoryCard(
                title: 'Social',
                icon: Icons.public,
                isExpanded: showSocial,
                onTap: () {
                  setState(() {
                    showSocial = !showSocial;
                    showScience = false;
                  });
                },
                subjects: socialSubjects,
                onSubjectTap: (subject) =>
                    onSubjectSelected('Social', subject),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
