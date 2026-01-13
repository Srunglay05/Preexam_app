class AppUser {
  final String uid;
  final String email;
  final String username;
  final String role; // admin | user
  final String? profileUrl;

  AppUser({
    required this.uid,
    required this.email,
    required this.username,
    required this.role,
    this.profileUrl,
  });

  // 🔥 WRITE TO FIRESTORE
  // ❗ DO NOT use this to overwrite existing users
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'role': role,
      'profileUrl': profileUrl,
    };
  }

  // 🔥 READ FROM FIRESTORE
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      role: map['role'] ?? 'user', // safe default
      profileUrl: map['profileUrl'],
    );
  }
}
