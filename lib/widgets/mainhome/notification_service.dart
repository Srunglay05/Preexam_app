import 'package:flutter/foundation.dart'; // <-- for kIsWeb
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// Callback when notification is triggered
  static void Function(int id)? onNotificationTriggered;

  static Future<void> init() async {
    if (kIsWeb) return; // Skip initialization on web
    if (_initialized) return; // Only initialize once
    _initialized = true;

    // Initialize timezone data
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        if (onNotificationTriggered != null) {
          onNotificationTriggered!(details.id ?? 0);
        }
      },
    );

    print("🔔 NotificationService initialized");
  }

  /// Schedule a notification 3 minutes before the original time
  /// and repeat it every day
  static Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    if (kIsWeb) return; // Skip on web
    await init(); // Ensure initialization

    final alertTime = scheduledTime.subtract(const Duration(minutes: 3));
    final tzAlertTime = tz.TZDateTime.from(alertTime, tz.local);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzAlertTime,
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
      matchDateTimeComponents: DateTimeComponents.time,
    );

    print("✅ Daily reminder scheduled 3 min early: $title at $tzAlertTime");
  }

  /// Cancel a specific notification by ID
  static Future<void> cancelNotification(int id) async {
    if (kIsWeb) return; // Skip on web
    await init();
    await _notificationsPlugin.cancel(id);
    print("🗑️ Notification cancelled: ID $id");
  }

  /// Cancel all notifications
  static Future<void> cancelAll() async {
    if (kIsWeb) return; // Skip on web
    await init();
    await _notificationsPlugin.cancelAll();
    print("🗑️ All notifications cancelled");
  }
}
