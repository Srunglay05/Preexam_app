import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../controllers/reminder_controller.dart';
import '../../models/reminder.dart';
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

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  /// ⏰ Modern Cupertino Time Picker
  Future<void> pickTime() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SizedBox(
          height: 280,
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: false,
                  initialDateTime: DateTime(
                    0,
                    0,
                    0,
                    selectedTime.hour,
                    selectedTime.minute,
                  ),
                  onDateTimeChanged: (dt) {
                    setState(() {
                      selectedTime = TimeOfDay.fromDateTime(dt);
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  /// 🔹 Combine the current date with selected time
DateTime getScheduledDateTime() {
  final now = DateTime.now();
  DateTime scheduledDateTime = DateTime(
    widget.reminder.dateTime.year,
    widget.reminder.dateTime.month,
    widget.reminder.dateTime.day,
    selectedTime.hour,
    selectedTime.minute,
  );

  // If the selected time already passed today, schedule for tomorrow
  if (scheduledDateTime.isBefore(now)) {
    scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
  }

  return scheduledDateTime;
}


  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReminderController>();

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        title: const Text(
          "Edit Reminder",
          style: TextStyle(
            fontFamily: 'Teacher',
            fontSize: 25,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                "assets/images/timez.png",
                height: 190,
                fit: BoxFit.contain,
              ),
            ),

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

                  /// ⏰ Time Picker
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

            const SizedBox(height: 40),

            /// 🔘 Save Button
            Align(
              alignment: Alignment.center,
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
                    final updatedReminder = Reminder(
                      id: widget.reminder.id,
                      title: titleCtrl.text,
                      description: descCtrl.text,
                      dateTime: getScheduledDateTime(), // use function here
                    );

                    controller.updateReminder(widget.index, updatedReminder);

                    NotificationService.scheduleReminder(
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
          ],
        ),
      ),
    );
  }
}
