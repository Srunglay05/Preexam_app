import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prexam/models/Appuser.dart';
import 'package:prexam/screens/login.dart';

class RegisterController extends GetxController {
  // Text controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // UI state
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;

  // 🔽 ROLE SELECTION (User / Admin)
  final RxString selectedRole = 'User'.obs;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Google Sign-In
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

      User? user = userCredential.user;
      if (user == null) {
        Get.snackbar("Error", "User creation failed");
        return;
      }

      // Send verification email
      await user.sendEmailVerification();

      // Save user to Firestore WITH ROLE
      AppUser newUser = AppUser(
        uid: user.uid,
        email: email,
        username: username,
        role: selectedRole.value, // 🔥 ROLE SAVED
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(newUser.toMap());

      Get.snackbar(
        "Success",
        "Account created. Please verify your email.",
      );

      Get.offAll(() => LoginScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Auth Error", e.message ?? "Registration failed");
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // =======================
  // GOOGLE SIGN-IN
  // =======================
  Future<void> registerWithGoogle() async {
    try {
      isLoading.value = true;
      UserCredential userCredential;

      if (kIsWeb) {
        GoogleAuthProvider provider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(provider);
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
      if (user == null) {
        Get.snackbar("Error", "Google Sign-In failed");
        return;
      }

      // Save / merge user WITH ROLE
      AppUser newUser = AppUser(
        uid: user.uid,
        email: user.email ?? "",
        username: user.displayName ?? "User",
        role: selectedRole.value, // 🔥 ROLE SAVED
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(newUser.toMap(), SetOptions(merge: true));

      Get.snackbar("Success", "Signed in with Google");
      Get.offAll(() => LoginScreen());
    } catch (e) {
      Get.snackbar("Error", "Google Sign-In failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
