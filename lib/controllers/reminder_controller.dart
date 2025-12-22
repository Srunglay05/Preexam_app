import 'package:get/get.dart';
import '../models/reminder.dart';
import '../widgets/mainhome/notification_service.dart';

class ReminderController extends GetxController {
  var reminders = <Reminder>[].obs;
  var firedNotifications = 0.obs; // track notifications that fired

  void addReminder(Reminder reminder) {
    reminders.add(reminder);

    NotificationService.scheduleNotification(
      id: reminder.id,
      title: reminder.title,
      body: reminder.description,
      scheduledTime: reminder.dateTime,
    );
  }

  void deleteReminder(int index) {
    reminders.removeAt(index);
    NotificationService.cancelAll();
  }

  void updateReminder(int index, Reminder updated) {
    reminders[index] = updated;
    reminders.refresh();

    NotificationService.scheduleNotification(
      id: updated.id,
      title: updated.title,
      body: updated.description,
      scheduledTime: updated.dateTime,
    );
  }

  /// Called when notification fires
  void incrementFiredCount() {
    firedNotifications.value++;
  }
}
