import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prexam/admin/options_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// SCREENS
import 'package:prexam/screens/mainhome.dart';

class LoginController extends GetxController {
  // =====================
  // TEXT CONTROLLERS
  // =====================
  final username = TextEditingController();
  final password = TextEditingController();

  // =====================
  // UI STATE
  // =====================
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;

  // 🔽 ROLE DROPDOWN (UI ONLY)
  // final RxString selectedRole = 'User'.obs;

  // =====================
  // FIREBASE
  // =====================
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final GoogleSignIn _googleSignIn;

  LoginController() {
    _googleSignIn = kIsWeb
        ? GoogleSignIn(
            clientId:
                "362443042369-h2hklv7bqq12j6mtc1l4m6fsumbg3oqd.apps.googleusercontent.com",
            scopes: ['email'],
          )
        : GoogleSignIn();
  }

  // =====================
  // EMAIL LOGIN
  // =====================
  Future<void> login() async {
    print("Login() called with email: ${username.text}");

    if (username.text.isEmpty || password.text.isEmpty) {
      Get.snackbar("Error", "Email and password cannot be empty");
      return;
    }

    isLoading.value = true;

    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: username.text.trim(),
        password: password.text.trim(),
      );

      User? user = userCredential.user;

      if (user == null) {
        Get.snackbar("Error", "Login failed");
        return;
      }

      print("Firebase login SUCCESS");
      print("UID: ${user.uid}");

      await _handlePostLogin(user);

    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.code}");
      Get.snackbar("Login Error", e.message ?? "Login failed");
    } catch (e) {
      print("Unknown login error: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  // =====================
  // GOOGLE LOGIN
  // =====================
  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      UserCredential userCredential;

      if (kIsWeb) {
        userCredential =
            await _auth.signInWithPopup(GoogleAuthProvider());
      } else {
        final GoogleSignInAccount? googleUser =
            await _googleSignIn.signIn();
        if (googleUser == null) return;

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential =
            await _auth.signInWithCredential(credential);
      }

      User? user = userCredential.user;
      if (user == null) return;

      print("Google login SUCCESS");
      print("UID: ${user.uid}");

      await _handlePostLogin(user);

    } catch (e) {
      print("Google login error: $e");
      Get.snackbar("Error", "Google login failed");
    } finally {
      isLoading.value = false;
    }
  }

  // =====================
  // ROLE CHECK & REDIRECT
  // =====================
  Future<void> _handlePostLogin(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // SAVE SESSION
    await prefs.setString("uid", user.uid);
    await prefs.setString("email", user.email ?? "");
    await prefs.setBool("isLoggedIn", true);

    // 🔥 REAL ROLE COMES FROM FIRESTORE
    final doc =
        await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      Get.snackbar("Error", "User record not found");
      return;
    }
// 🔥 READ ROLE SAFELY FROM FIRESTORE
      final data = doc.data() as Map<String, dynamic>;
      final role = data['role']?.toString().trim().toLowerCase() ?? 'user';

      // 🔍 DEBUG (VERY IMPORTANT)
      print("🔥 UID: ${user.uid}");
      print("🔥 ROLE FROM FIRESTORE: $role");

      if (role == 'admin') {
        Get.offAll(() => OptionsScreen()); // ADMIN
      } else {
        Get.offAll(() => HomeMainScreen()); // USER
      }

  }

  // =====================
  // FORGOT PASSWORD
  // =====================
  Future<void> forgotPassword() async {
    final email = username.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email first");
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        "Success",
        "Password reset email sent.\nCheck Inbox & Spam.",
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Failed to send reset email");
    }
  }

  // =====================
  // CLEANUP
  // =====================
  @override
  void onClose() {
    username.dispose();
    password.dispose();
    super.onClose();
  }
}
