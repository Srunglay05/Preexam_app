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
      appBar: AppBar(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          title: const Text(
            "Create Reminder",
            style: TextStyle(
              fontFamily: 'Teacher',
              fontSize: 25,
              ),
          ),
        ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 📦 Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
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
                      controller: titleCtrl,
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
                      controller: descCtrl,
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

              /// 🔘 Save Button (CENTER + UP 20px)
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    width: 140,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
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

                        controller.updateReminder(
                          widget.index,
                          updatedReminder,
                        );

                        /// 🔔 Reschedule notification
                        NotificationService.scheduleNotification(
                          id: updatedReminder.id,
                          title: updatedReminder.title,
                          body: updatedReminder.description,
                          scheduledTime: updatedReminder.dateTime,
                        );

                        Get.back();
                      },
                      child: const Text(
                        "Save",
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
      ),
    );
  }
}
