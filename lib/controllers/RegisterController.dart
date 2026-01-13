import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prexam/screens/authentication/login.dart';

class RegisterController extends GetxController {
  // =======================
  // TEXT CONTROLLERS
  // =======================
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // UI STATE
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;

  // FIREBASE
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // GOOGLE SIGN-IN
  late final GoogleSignIn _googleSignIn;

  RegisterController() {
    _googleSignIn = kIsWeb
        ? GoogleSignIn(
            clientId:
                "362443042369-h2hklv7bqq12j6mtc1l4m6fsumbg3oqd.apps.googleusercontent.com",
            scopes: ['email'],
          )
        : GoogleSignIn();
  }

  // =======================
  // EMAIL & PASSWORD REGISTER
  // =======================
  Future<void> register() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    if (password.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters");
      return;
    }

    try {
      isLoading.value = true;

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) return;

      // Send verification email
      await user.sendEmailVerification();

      final userRef = _firestore.collection('users').doc(user.uid);
      final doc = await userRef.get();

      // 🔐 CREATE USER ONLY ONCE
      if (!doc.exists) {
        await userRef.set({
          'uid': user.uid,
          'email': email,
          'username': username,
          'role': 'user', // ✅ set once
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      Get.snackbar(
        "Success",
        "Account created. Please verify your email.",
      );

      Get.offAll(() => LoginScreen());

    } on FirebaseAuthException catch (e) {
      Get.snackbar("Auth Error", e.message ?? "Registration failed");
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  // =======================
  // GOOGLE SIGN-IN REGISTER
  // =======================
  Future<void> registerWithGoogle() async {
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

      final user = userCredential.user;
      if (user == null) return;

      final userRef = _firestore.collection('users').doc(user.uid);
      final doc = await userRef.get();

      // 🔐 CREATE ONLY IF NOT EXISTS
      if (!doc.exists) {
        await userRef.set({
          'uid': user.uid,
          'email': user.email ?? '',
          'username': user.displayName ?? 'User',
          'role': 'user', // ✅ NEVER overwrite
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      Get.snackbar("Success", "Signed in with Google");
      Get.offAll(() => LoginScreen());

    } catch (e) {
      Get.snackbar("Error", "Google Sign-In failed");
    } finally {
      isLoading.value = false;
    }
  }

  // =======================
  // CLEAN UP
  // =======================
  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
