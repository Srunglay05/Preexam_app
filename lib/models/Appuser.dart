class AppUser {
  String uid;
  String email;
  String username;
  String? profileUrl; 

  AppUser({
    required this.uid,
    required this.email,
    required this.username,
    this.profileUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'profileUrl': profileUrl,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? "",
      username: map['username'] ?? "",
      email: map['email'] ?? "",
      profileUrl: map['profileUrl'], // nullable
    );
  }
}
