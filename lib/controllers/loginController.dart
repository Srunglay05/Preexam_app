import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// SCREENS
import 'package:prexam/admin/options_screen.dart';
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

  // =====================
  // FIREBASE
  // =====================
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final GoogleSignIn _googleSignIn;

  get selectedRole => null;

  @override
  void onInit() {
    super.onInit();
    _googleSignIn = kIsWeb
        ? GoogleSignIn(
            clientId:
                "YOUR_WEB_CLIENT_ID.apps.googleusercontent.com",
            scopes: ['email'],
          )
        : GoogleSignIn();
  }

  // =====================
  // EMAIL LOGIN
  // =====================
  Future<void> login() async {
    if (username.text.isEmpty || password.text.isEmpty) {
      Get.snackbar("Error", "Email and password required");
      return;
    }

    try {
      isLoading.value = true;

      final userCredential =
          await _auth.signInWithEmailAndPassword(
        email: username.text.trim(),
        password: password.text.trim(),
      );

      final user = userCredential.user;
      if (user == null) return;

      await _redirectByRole(user.uid);

    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Error", e.message ?? "Login failed");
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
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return;

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential =
            await _auth.signInWithCredential(credential);
      }

      final user = userCredential.user;
      if (user == null) return;

      await _redirectByRole(user.uid);

    } catch (e) {
      Get.snackbar("Error", "Google login failed");
    } finally {
      isLoading.value = false;
    }
  }

  // =====================
  // ROLE CHECK
  // =====================
  Future<void> _redirectByRole(String uid) async {
    final doc =
        await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      Get.snackbar("Error", "User record not found");
      return;
    }

    final role = doc['role'] ?? 'user';

    if (role == 'admin') {
      Get.offAll(() =>  OptionsScreen());
    } else {
      Get.offAll(() =>  HomeMainScreen());
    }
  }

  // =====================
  // FORGOT PASSWORD
  // =====================
  Future<void> forgotPassword() async {
    if (username.text.isEmpty) {
      Get.snackbar("Error", "Enter email first");
      return;
    }

    await _auth.sendPasswordResetEmail(
      email: username.text.trim(),
    );

    Get.snackbar("Success", "Reset email sent");
  }

  @override
  void onClose() {
    username.dispose();
    password.dispose();
    super.onClose();
  }
}
