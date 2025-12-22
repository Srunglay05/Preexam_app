import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reminder_controller.dart';
import '../models/reminder.dart';
import 'package:prexam/widgets/mainhome/notification_service.dart';
class EditReminderPage extends StatefulWidget {
  final Reminder reminder;
  final int index;

  const EditReminderPage({
    super.key,
    required this.reminder,
    required this.index,
  });

  @override
  State<EditReminderPage> createState() => _EditReminderPageState();
}

class _EditReminderPageState extends State<EditReminderPage> {
  late TextEditingController titleCtrl;
  late TextEditingController descCtrl;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.reminder.title);
    descCtrl = TextEditingController(text: widget.reminder.description);

    selectedTime = TimeOfDay(
      hour: widget.reminder.dateTime.hour,
      minute: widget.reminder.dateTime.minute,
    );
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
      appBar: AppBar(title: const Text("Edit Reminder")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Title Input
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 15),

            // Description Input
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 20),

            // Time Picker
            GestureDetector(
              onTap: pickTime,
              child: Container(
                padding: const EdgeInsets.all(15),
                color: Colors.grey[200],
                child: Text("Time: ${selectedTime.format(context)}"),
              ),
            ),

            const SizedBox(height: 30),

            // Save Button
            ElevatedButton(
              onPressed: () {
                final updatedDateTime = DateTime(
                  widget.reminder.dateTime.year,
                  widget.reminder.dateTime.month,
                  widget.reminder.dateTime.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                final updatedReminder = Reminder(
                  id: widget.reminder.id,
                  title: titleCtrl.text,
                  description: descCtrl.text,
                  dateTime: updatedDateTime,
                );

                controller.updateReminder(widget.index, updatedReminder);

                // Optionally, reschedule notification
                NotificationService.scheduleNotification(
                  id: updatedReminder.id,
                  title: updatedReminder.title,
                  body: updatedReminder.description,
                  scheduledTime: updatedReminder.dateTime,
                );

                Get.back();
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
