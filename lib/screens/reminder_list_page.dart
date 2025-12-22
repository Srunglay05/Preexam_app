import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:prexam/screens/mainhome.dart';
import '../controllers/reminder_controller.dart';
import 'create_reminder_page.dart';
import 'edit_reminder_page.dart';

class ReminderListPage extends StatelessWidget {
  const ReminderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReminderController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Header
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Today.",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Teacher",
                        ),
                      ),
                      Text(
                        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontFamily: "Teacher",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Reminder list
            Expanded(
              child: Obx(() {
                if (controller.reminders.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Reminders Yet",
                      style: TextStyle(fontSize: 20, fontFamily: "Teacher"),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: controller.reminders.length,
                  itemBuilder: (_, index) {
                    final reminder = controller.reminders[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              "assets/images/study.jpg",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reminder.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Teacher",
                                  ),
                                ),
                                Text(
                                  reminder.description,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 15,
                                    fontFamily: "Teacher",
                                  ),
                                ),
                                Text(
                                   "${reminder.dateTime.hour}:${reminder.dateTime.minute.toString().padLeft(2, '0')}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontFamily: "Teacher",
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Column(
                            children: [
                              // EDIT BUTTON (GREEN)
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => EditReminderPage(
                                        reminder: reminder,
                                        index: index,
                                      ));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.edit,
                                      color: Colors.white, size: 20),
                                ),
                              ),

                              const SizedBox(height: 10),

                              // DELETE BUTTON (RED)
                              GestureDetector(
                                onTap: () {
                                  controller.deleteReminder(index);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              }),
            ),

            // Add button
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: SizedBox(
                  width: 120,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => Get.to(() => const CreateReminderPage()),
                    child: const Text(
                      "Add",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: "Teacher",
                      ), 
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
