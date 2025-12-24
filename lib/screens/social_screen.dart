import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  // Example data for the list
  final List<Map<String, dynamic>> socialTasks = const [
    {'icon': Icons.nature_people, 'title': 'Citizens ~ Ethics'},
    {'icon': Icons.landscape, 'title': 'Geography'},
    {'icon': Icons.calculate, 'title': 'Mathematics'},
    {'icon': Icons.public, 'title': 'Earth Science'},
    {'icon': Icons.book, 'title': 'Khmer Literature'},
    {'icon': Icons.map_sharp, 'title': 'Historial'},
    {'icon': Icons.my_library_books, 'title': 'English Literature'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 244, 143, 143),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Social Task',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Teacher',
            fontSize: 23,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: socialTasks.length,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final task = socialTasks[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 70,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 253, 178, 178),
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
                  color: Color.fromARGB(255, 213, 98, 98),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Center(
                    child: Text(
                      task['title'],
                      style: TextStyle(
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
