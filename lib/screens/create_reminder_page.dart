import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reminder_controller.dart';
import '../models/reminder.dart';
import '../widgets/mainhome/notification_service.dart';

class CreateReminderPage extends StatefulWidget {
  const CreateReminderPage({super.key});

  @override
  State<CreateReminderPage> createState() => _CreateReminderPageState();
}

class _CreateReminderPageState extends State<CreateReminderPage> {
  final subjectCtrl = TextEditingController();
  final detailCtrl = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    subjectCtrl.dispose();
    detailCtrl.dispose();
    super.dispose();
  }

  Future<void> pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (t != null) setState(() => selectedTime = t);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReminderController>();

    return Scaffold(
      backgroundColor: Colors.white,

      /// 🧭 Toolbar
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          "Create Reminder",
          style: TextStyle(
            fontFamily: "Teacher",
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                "assets/images/timee.png",
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
            /// 📅 Date
            Text(
              "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontFamily: "Teacher",
              ),
            ),

            const SizedBox(height: 10),

            /// 📦 Card (same as EditReminder)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Title",
                    style: TextStyle(
                      fontFamily: "Teacher",
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: subjectCtrl,
                    style: const TextStyle(fontFamily: "Teacher"),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Description",
                    style: TextStyle(
                      fontFamily: "Teacher",
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: detailCtrl,
                    style: const TextStyle(fontFamily: "Teacher"),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ⏰ Time Picker (LEFT)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: pickTime,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          selectedTime.format(context),
                          style: const TextStyle(
                            fontSize: 26,
                            fontFamily: "Teacher",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            /// 🔘 Submit Button (same style as EditReminder)
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: 140,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      if (subjectCtrl.text.isEmpty ||
                          detailCtrl.text.isEmpty) {
                        Get.snackbar("Error", "Please fill all fields");
                        return;
                      }

                      final reminder = Reminder(
                        id: DateTime.now().millisecondsSinceEpoch,
                        title: subjectCtrl.text,
                        description: detailCtrl.text,
                        dateTime:
                            DateTime.now().add(const Duration(minutes: 3)),
                      );

                      controller.addReminder(reminder);

                      NotificationService.scheduleReminder(
                      id: reminder.id,
                      title: reminder.title,
                      body: reminder.description,
                      scheduledTime: reminder.dateTime,
                    );

                      NotificationService.onNotificationTriggered = (id) {
                        controller.incrementFiredCount();
                      };

                      Get.back();
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Teacher",
                        color: Colors.white,
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
