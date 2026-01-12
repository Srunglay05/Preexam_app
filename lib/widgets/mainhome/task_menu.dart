import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:prexam/screens/create_reminder_page.dart';
import 'package:prexam/screens/score_input.dart';
import 'package:prexam/screens/solution_screen.dart';
import 'package:prexam/screens/task_screen.dart';

class TaskMenu extends StatelessWidget {
  const TaskMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(11),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 15,
          runSpacing: 10,
          children: [
            /// COLUMN 1
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCard(
                  color: const Color.fromARGB(255, 254, 152, 188),
                  title: "Task",
                  icon: FontAwesomeIcons.clipboardCheck,
                  onTap: () {
                    Get.to(() => TaskScreen());
                  },
                ),
                const SizedBox(height: 10),
                _buildCard(
                  color: Colors.lightBlueAccent,
                  title: "Tally Score",
                  icon: FontAwesomeIcons.calculator,
                  onTap: () {
                    Get.to(() => ScoreInputPage());
                  },
                ),
              ],
            ),

            /// COLUMN 2
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCard(
                  color: const Color.fromARGB(255, 188, 166, 255),
                  title: "Reminder",
                  icon: FontAwesomeIcons.bell,
                  onTap: () {
                    Get.to(() => CreateReminderPage());
                  },
                ),
                const SizedBox(height: 10),
                _buildCard(
                  color: const Color.fromARGB(255, 255, 199, 139),
                  title: "Solution",
                  icon: FontAwesomeIcons.lightbulb,
                  onTap: () {
                    Get.to(() => SolutionScreen());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ================= CARD UI =================
  Widget _buildCard({
    required Color color,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 145,
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [

          /// ICON + TITLE
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FaIcon(icon, size: 22, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Teacher',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          /// + BUTTON
          Positioned(
            right: 0.1,
            top: 0.1,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.add,
                  size: 18,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
