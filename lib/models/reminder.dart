class Reminder {
  int id; // unique
  String title;
  String description;
  DateTime dateTime;
  bool sent;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    this.sent = false
  });
}
