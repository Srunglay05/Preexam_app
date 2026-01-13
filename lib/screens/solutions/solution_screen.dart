import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prexam/screens/solutions/solutionlist.dart';

class SolutionScreen extends StatelessWidget {
  const SolutionScreen({super.key});

  final List<Map<String, dynamic>> solutionTasks = const [
    {'icon': Icons.science, 'title': 'Physics'},
    {'icon': Icons.biotech, 'title': 'Biological'},
    {'icon': Icons.calculate, 'title': 'Mathematics'},
    {'icon': Icons.science_outlined, 'title': 'Chemistry'},
    {'icon': Icons.book, 'title': 'Khmer Literature'},
    {'icon': Icons.map_outlined, 'title': 'History'},
    {'icon': Icons.nature_people, 'title': 'Morality'},
    {'icon': Icons.landscape, 'title': 'Geography'},
    {'icon': Icons.public, 'title': 'Earth Science'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Solution List',
          style: TextStyle(
            fontFamily: 'Teacher',
            fontSize: 23,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: solutionTasks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final task = solutionTasks[index];

          return Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Get.to(
                  () => SolutionListScreen(
                    subjectTitle: task['title'],
                  ),
                );
              },
              child: Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
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
                    Icon(
                      task['icon'],
                      size: 36,
                      color: const Color.fromARGB(255, 1, 92, 166),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Center(
                        child: Text(
                          task['title'],
                          style: const TextStyle(
                            fontFamily: 'Teacher',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
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
