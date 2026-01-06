import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reminder.dart';
import '../widgets/mainhome/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReminderController extends GetxController {
  var reminders = <Reminder>[].obs;
  var firedNotifications = 0.obs; // track notifications that fired

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get current user
  User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
    // Load reminders automatically when controller is created
    loadReminders();
  }

  /// Add reminder locally, schedule notification, and save to Firebase
  Future<void> addReminder(Reminder reminder) async {
    if (currentUser == null) return;

    // Generate unique ID if not set
    final id = reminder.id != 0 ? reminder.id : DateTime.now().millisecondsSinceEpoch;
    reminder.id = id;

    // Add to local list
    reminders.add(reminder);

    // Schedule notification
    NotificationService.scheduleReminder(
      id: reminder.id,
      title: reminder.title,
      body: reminder.description,
      scheduledTime: reminder.dateTime,
    );

    try {
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('reminders')
          .doc(reminder.id.toString())
          .set({
        'id': reminder.id,
        'title': reminder.title,
        'description': reminder.description,
        'dateTime': reminder.dateTime.toIso8601String(),
      });
      print("✅ Reminder saved for user ${currentUser!.email}: ${reminder.title}");
    } catch (e, s) {
      print("❌ Failed to save reminder: $e");
      print(s);
    }
  }

  /// Delete reminder
  Future<void> deleteReminder(int index) async {
    if (currentUser == null) return;
    Reminder reminder = reminders[index];
    reminders.removeAt(index);

    NotificationService.cancelAll();

    try {
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('reminders')
          .doc(reminder.id.toString())
          .delete();
      print("🗑️ Reminder deleted for user ${currentUser!.email}: ${reminder.title}");
    } catch (e) {
      print('Error deleting reminder from Firebase: $e');
    }
  }

  /// Update reminder
  Future<void> updateReminder(int index, Reminder updated) async {
    if (currentUser == null) return;
    reminders[index] = updated;
    reminders.refresh();

    NotificationService.scheduleReminder(
      id: updated.id,
      title: updated.title,
      body: updated.description,
      scheduledTime: updated.dateTime,
    );

    try {
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('reminders')
          .doc(updated.id.toString())
          .update({
        'title': updated.title,
        'description': updated.description,
        'dateTime': updated.dateTime.toIso8601String(),
      });
      print("✏️ Reminder updated for user ${currentUser!.email}: ${updated.title}");
    } catch (e) {
      print('Error updating reminder in Firebase: $e');
    }
  }

  /// Load reminders for current user
  Future<void> loadReminders() async {
    if (currentUser == null) return;

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('reminders')
          .get();

      List<Reminder> loaded = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Safe id
        final int id = data['id'] ?? DateTime.now().millisecondsSinceEpoch;

        // Safe dateTime
        DateTime dt;
        if (data['dateTime'] is String) {
          dt = DateTime.parse(data['dateTime']);
        } else if (data['dateTime'] is Timestamp) {
          dt = (data['dateTime'] as Timestamp).toDate();
        } else {
          dt = DateTime.now(); // fallback
        }

        return Reminder(
          id: id,
          title: data['title'] ?? 'No title',
          description: data['description'] ?? '',
          dateTime: dt,
        );
      }).toList();

      reminders.assignAll(loaded);
      print("✅ Loaded ${loaded.length} reminders for user ${currentUser!.email}");
    } catch (e) {
      print('Error loading reminders from Firebase: $e');
    }
  }

  /// Called when notification fires
  void incrementFiredCount() {
    firedNotifications.value++;
  }
}
