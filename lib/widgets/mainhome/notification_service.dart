import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;


class NotificationService {
  static final _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Function(int id)? onNotificationTriggered;

  /// Initialize notifications
  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        final id = response.notificationResponseType.index;
        if (onNotificationTriggered != null) {
          onNotificationTriggered!(id);
        }
      },
    );
  }

  /// Request notification permission (for iOS / Android 13+)
  static Future<void> requestPermission() async {
    try {
      final granted = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();

      if (granted != null && granted) {
        debugPrint('✅ Notification permission granted');
      } else {
        debugPrint('❌ Notification permission denied');
      }
    } catch (e) {
      debugPrint('❌ Error requesting permission: $e');
    }
  }

  /// Schedule a reminder
  static Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
  id,
  title,
  body,
  tz.TZDateTime.from(scheduledTime, tz.local), // ✅ convert DateTime -> TZDateTime
  const NotificationDetails(
    android: AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
    ),
  ),
  androidAllowWhileIdle: true,
  uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
);
  }

  /// Cancel a notification
  static Future<void> cancelReminder(int id) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id);
      debugPrint("🛑 Notification cancelled: $id");
    } catch (e) {
      debugPrint("❌ Failed to cancel notification $id: $e");
    }
  }
}
