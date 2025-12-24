import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SolutionScreen extends StatelessWidget{
  const SolutionScreen({super.key});

  final List<Map<String, dynamic>> solutionTasks = const [
    {'icon': Icons.science, 'title': 'Physics'},
    {'icon': Icons.biotech, 'title': 'Biological'},
    {'icon': Icons.calculate, 'title': 'Mathematics'},
    {'icon': Icons.science_outlined, 'title': 'Chemistry'},
    {'icon': Icons.book, 'title': 'Khmer Literature'},
    {'icon': Icons.map_outlined, 'title': 'Historial'},
    {'icon': Icons.my_library_books, 'title': 'English Literature'},
    {'icon': Icons.nature_people, 'title': 'Citizens ~ Ethics'},
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
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30, // 👈 CUSTOM BACK ICON SIZE
          ),
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
        padding: EdgeInsets.all(16),
        itemCount: solutionTasks.length,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final task = solutionTasks[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 70,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(0, 3),
                  blurRadius: 6,
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
                SizedBox(width: 16),
                Expanded(
                  child: Center(
                    child: Text(
                      task['title'],
                      style: TextStyle(
                        color: Colors.black,
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
          );
        },
      ),
    );
  }
}