class AppUser {
  String uid;
  String email;
  String username;
  String role; // ✅ ADDED
  String? profileUrl;

  AppUser({
    required this.uid,
    required this.email,
    required this.username,
    required this.role, // ✅ REQUIRED
    this.profileUrl,
  });

  // 🔥 Save to Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'role': role, // ✅ SAVED
      'profileUrl': profileUrl,
    };
  }

  // 🔥 Read from Firestore
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      role: map['role'] ?? 'User', // ✅ DEFAULT ROLE
      profileUrl: map['profileUrl'],
    );
  }
}
