import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../controllers/reminder_controller.dart';
import '../../models/reminder.dart';

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
              // Top handle
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
                  initialDateTime: DateTime(
                    0,
                    0,
                    0,
                    selectedTime.hour,
                    selectedTime.minute,
                  ),
                  use24hFormat: false,
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

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReminderController>();

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          "Create Reminder",
          style: TextStyle(
            fontFamily: "Teacher",
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
                "assets/images/timee.png",
                height: 180,
              ),
            ),

            Text(
              "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontFamily: "Teacher",
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Title",
                      style:
                          TextStyle(fontFamily: "Teacher", fontSize: 16)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: subjectCtrl,
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

                  const Text("Description",
                      style:
                          TextStyle(fontFamily: "Teacher", fontSize: 16)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: detailCtrl,
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

            Align(
              alignment: Alignment.center,
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
                    final reminder = Reminder(
                      id: DateTime.now().millisecondsSinceEpoch,
                      title: subjectCtrl.text,
                      description: detailCtrl.text,
                      dateTime: DateTime.now(),
                    );

                    controller.addReminder(reminder);
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
          ],
        ),
      ),
    );
  }
}
