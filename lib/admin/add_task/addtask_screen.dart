import 'package:flutter/material.dart';
import 'package:prexam/admin/add_task/addtask_dialog.dart';
import 'package:prexam/admin/add_task/categoriescard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:prexam/controllers/task_controller.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  bool showScience = false;
  bool showSocial = false;

  final TaskController taskController = Get.put(TaskController());

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
      onPost: () => taskController.fetchTasks(),
    );
  }

  Future<String> getAdminName() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists) return "Admin";
    return doc['username'] ?? "Admin";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: FutureBuilder<String>(
          future: getAdminName(),
          builder: (context, snapshot) {
            final adminName = snapshot.data ?? 'Admin';
            return Text(
              'Add Task • $adminName',
              style: const TextStyle(fontFamily: 'Teacher', fontSize: 22),
            );
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F7FB), Color(0xFF2196F3)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔹 Category Cards ONLY
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
                onSubjectTap: (subject) => onSubjectSelected('Social', subject),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
