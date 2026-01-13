class Task {
  String id;
  String title;
  String description;
  String category;
  String addedBy;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.addedBy,
  });

  // 🔹 Convert Firestore document to Task object
  factory Task.fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      addedBy: map['addedBy'] ?? '',
    );
  }

  // 🔹 Convert Task object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'addedBy': addedBy,
    };
  }
}
