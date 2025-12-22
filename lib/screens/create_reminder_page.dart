import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reminder_controller.dart';
import '../models/reminder.dart';
import '../widgets/mainhome/notification_service.dart'; // make sure this is imported

class CreateReminderPage extends StatefulWidget {
  const CreateReminderPage({super.key});

  @override
  State<CreateReminderPage> createState() => _CreateReminderPageState();
}

class _CreateReminderPageState extends State<CreateReminderPage> {
  final subjectCtrl = TextEditingController();
  final detailCtrl = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

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
      appBar: AppBar(title: const Text("Create Reminder")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: subjectCtrl,
              decoration: const InputDecoration(hintText: 'Subject'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: detailCtrl,
              decoration: const InputDecoration(hintText: 'Detail'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: pickTime,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  selectedTime.format(context),
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                if (subjectCtrl.text.isEmpty || detailCtrl.text.isEmpty) {
                  Get.snackbar("Error", "Please fill all fields");
                  return;
                }

                // 🔹 For testing: schedule notification 5 seconds from now
                final scheduledDateTime = DateTime.now().add(const Duration(minutes: 3));
                final reminder = Reminder(
                  id: DateTime.now().millisecondsSinceEpoch,
                  title: subjectCtrl.text,
                  description: detailCtrl.text,
                  dateTime: scheduledDateTime,
                );

                controller.addReminder(reminder);

                // Debug prints
                print("✅ Reminder scheduled:");
                print("Title: ${reminder.title}");
                print("Description: ${reminder.description}");
                print("Scheduled for: ${reminder.dateTime}");

                // Schedule notification debug
                NotificationService.scheduleNotification(
                  id: reminder.id,
                  title: reminder.title,
                  body: reminder.description,
                  scheduledTime: reminder.dateTime,
                );

                // Listen for when it triggers (for debugging)
                NotificationService.onNotificationTriggered = (id) {
                  print("🔔 Reminder triggered! ID: $id");
                  controller.incrementFiredCount(); // update badge
                };

                Get.back();

                Get.snackbar(
                  "Reminder Set",
                  "It will notify in 5 seconds for testing",
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
