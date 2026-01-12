import 'package:flutter/material.dart';

class NotificationInboxScreen extends StatelessWidget {
  const NotificationInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy notification data (replace later with real storage)
    final notifications = [
      {
        'title': 'Time to Study',
        'message': 'Study Physics now',
        'subject': 'Physics',
        'time': '08:00 PM',
        'read': false,
      },
      {
        'title': 'Reminder',
        'message': 'Revise Mathematics',
        'subject': 'Mathematics',
        'time': '06:30 AM',
        'read': true,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,

      /// 🔵 APP BAR
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Teacher',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      /// 📥 NOTIFICATION LIST
      body: notifications.isEmpty
          ? _emptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _notificationCard(notification);
              },
            ),
    );
  }

  /// 🔔 NOTIFICATION CARD
  Widget _notificationCard(Map<String, dynamic> data) {
    final bool isRead = data['read'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ICON
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isRead
                  ? Colors.grey.shade200
                  : Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications,
              color: isRead ? Colors.grey : Colors.blue,
            ),
          ),

          const SizedBox(width: 14),

          /// TEXT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title'],
                  style: TextStyle(
                    fontFamily: 'Teacher',
                    fontSize: 16,
                    fontWeight:
                        isRead ? FontWeight.w500 : FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data['message'],
                  style: const TextStyle(
                    fontFamily: 'Teacher',
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data['subject'],
                  style: const TextStyle(
                    fontFamily: 'Teacher',
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),

          /// TIME
          Text(
            data['time'],
            style: const TextStyle(
              fontFamily: 'Teacher',
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// 📭 EMPTY STATE (WHITE BACKGROUND)
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontFamily: 'Teacher',
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Study notifications will appear here',
            style: TextStyle(
              fontFamily: 'Teacher',
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
