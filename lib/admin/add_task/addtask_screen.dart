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
    'Computer',
    'Environmental Science',
  ];

  final List<String> socialSubjects = [
    'History',
    'Geography',
    'Civics',
    'Economics',
    'Political Science',
    'Sociology',
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
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Add Task', style: TextStyle(
          fontFamily: 'Teacher',
          fontSize: 22
        ),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
    );
  }
}
