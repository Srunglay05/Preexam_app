import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prexam/screens/pdfviewscreen.dart';
import 'package:prexam/admin/add_course/addcourse_screen.dart';
import 'package:prexam/admin/add_task/addtask_dialog.dart';
import 'package:prexam/screens/imagesviewscreen.dart';
import 'package:prexam/admin/add_solution/addsolution_screen.dart'; // <- Import the updated AddSolutionScreen

class AdminCourseScreen extends StatefulWidget {
  const AdminCourseScreen({super.key});

  @override
  State<AdminCourseScreen> createState() => _AdminCourseScreenState();
}

class _AdminCourseScreenState extends State<AdminCourseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final CollectionReference coursesCollection =
      FirebaseFirestore.instance.collection('courses');
  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');
  final CollectionReference solutionsCollection =
      FirebaseFirestore.instance.collection('solutions');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Admin Panel',
          style: TextStyle(fontFamily: 'Teacher', fontSize: 22),
        ),
        backgroundColor: Colors.blue,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Courses'),
            Tab(text: 'Tasks'),
            Tab(text: 'Solutions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          /// ------------------- COURSES TAB -------------------
          StreamBuilder<QuerySnapshot>(
            stream: coursesCollection
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No courses available'));
              }

              final courses = snapshot.data!.docs;

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: courses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        const Icon(Icons.picture_as_pdf,
                            color: Colors.red, size: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(course['title'] ?? 'Untitled',
                                  style: const TextStyle(
                                      fontFamily: 'Teacher',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(course['courseType'] ?? 'Unknown',
                                  style: const TextStyle(
                                      fontFamily: 'Teacher',
                                      fontSize: 14,
                                      color: Colors.grey)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.visibility, color: Colors.blue),
                          onPressed: () {
                            Get.to(() => PdfViewScreen(
                                  title: course['title'] ?? 'Untitled',
                                  pdfUrl: course['pdfUrl'] ?? '',
                                ));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            Get.to(() => AddCourseScreen(
                                  editCourseId: course.id,
                                  editTitle: course['title'],
                                  editCourseType: course['courseType'],
                                  editPdfUrl: course['pdfUrl'],
                                ));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            bool confirm = await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text(
                                    'Are you sure you want to delete this course?'),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Get.back(result: false),
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () => Get.back(result: true),
                                      child: const Text('Delete')),
                                ],
                              ),
                            );
                            if (confirm) {
                              await coursesCollection.doc(course.id).delete();
                              Get.snackbar('Deleted', 'Course has been deleted');
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          /// ------------------- TASKS TAB -------------------
          StreamBuilder<QuerySnapshot>(
            stream: tasksCollection
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No tasks available'));
              }

              final tasks = snapshot.data!.docs;

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: tasks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final taskData = task.data() as Map<String, dynamic>;

                  final imageUrl =
                      taskData.containsKey('imageUrl') ? taskData['imageUrl'] ?? '' : '';

                  return Container(
                    padding: const EdgeInsets.all(12),
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
                            ? Image.network(imageUrl,
                                width: 60, height: 60, fit: BoxFit.cover)
                            : const Icon(Icons.task, size: 40),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            taskData['title'] ?? 'Untitled Task',
                            style: const TextStyle(
                                fontFamily: 'Teacher',
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.visibility, color: Colors.blue),
                          onPressed: () {
                            if (imageUrl.isNotEmpty) {
                              Get.to(() => ImageViewScreen(
                                    title: taskData['title'] ?? 'Task Image',
                                    imageUrl: imageUrl,
                                  ));
                            } else {
                              Get.snackbar(
                                  'No Image', 'This task has no image to view');
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            showAddTaskDialog(
                              context: context,
                              taskId: task.id,
                              existingTitle: taskData['title'] ?? '',
                              existingImageUrl: taskData['imageUrl'] ?? '',
                              category: taskData['category'] ?? '',
                              subject: taskData['subject'] ?? '',
                              onPost: () {
                                setState(() {});
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            bool confirm = await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text(
                                    'Are you sure you want to delete this Task?'),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Get.back(result: false),
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () => Get.back(result: true),
                                      child: const Text('Delete')),
                                ],
                              ),
                            );
                            if (confirm) {
                              await tasksCollection.doc(task.id).delete();
                              Get.snackbar('Deleted', 'Task has been deleted');
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          /// ------------------- SOLUTIONS TAB -------------------
          StreamBuilder<QuerySnapshot>(
            stream: solutionsCollection
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No solutions available'));
              }

              final solutions = snapshot.data!.docs;

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: solutions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final solution = solutions[index];
                  final solutionData = solution.data() as Map<String, dynamic>;
                  final pdfUrl = solutionData['pdfUrl'] ?? '';

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
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
                        const Icon(Icons.picture_as_pdf,
                            color: Colors.red, size: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(solutionData['title'] ?? 'Untitled',
                                  style: const TextStyle(
                                      fontFamily: 'Teacher',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(solutionData['subject'] ?? 'Unknown',
                                  style: const TextStyle(
                                      fontFamily: 'Teacher',
                                      fontSize: 14,
                                      color: Colors.grey)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.visibility, color: Colors.blue),
                          onPressed: () {
                            if (pdfUrl.isEmpty) {
                              Get.snackbar('No PDF', 'This solution has no PDF.');
                              return;
                            }
                            Get.to(() => PdfViewScreen(
                                  title: solutionData['title'] ?? 'Untitled',
                                  pdfUrl: pdfUrl,
                                ));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            // Navigate to AddSolutionScreen with existing data
                            Get.to(() => AddSolutionScreen(
                                  solutionId: solution.id,
                                  existingTitle: solutionData['title'] ?? '',
                                  existingSubject: solutionData['subject'] ?? '',
                                  existingPdfUrl: pdfUrl,
                                ));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            bool confirm = await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text(
                                    'Are you sure you want to delete this solution?'),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Get.back(result: false),
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () => Get.back(result: true),
                                      child: const Text('Delete')),
                                ],
                              ),
                            );
                            if (confirm) {
                              await solutionsCollection
                                  .doc(solution.id)
                                  .delete();
                              Get.snackbar(
                                  'Deleted', 'Solution has been deleted');
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tabController.index == 0) {
            Get.to(() => const AddCourseScreen());
          } else if (_tabController.index == 1) {
            showAddTaskDialog(
              context: context,
              category: 'Science',
              subject: 'Physics',
              onPost: () {},
            );
          } else {
            // Navigate to AddSolutionScreen for adding new solution
            Get.to(() => const AddSolutionScreen());
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
