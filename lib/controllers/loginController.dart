import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prexam/screens/mainhome.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;



class LoginController extends GetxController {
  final username = TextEditingController();
  final password = TextEditingController();
  final isLoading = false.obs;
   final isPasswordHidden = true.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void login() async {
    print("Login() called with email: ${username.text}, password: ${password.text}");

    if (username.text.isEmpty || password.text.isEmpty) {
      print(" Error: Email or password is empty");
      Get.snackbar("Error", "Email and password cannot be empty");
      return;
    }

    isLoading.value = true;

    try {
      print("⏳ Attempting Firebase sign in...");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: username.text.trim(),
        password: password.text.trim(),
      );

      if (userCredential.user != null) {
        print("Firebase sign in SUCCESS");
        print("UID: ${userCredential.user!.uid}");
        print("Email verified: ${userCredential.user!.emailVerified}");

        //  ADD: show login provider
        for (var info in userCredential.user!.providerData) {
          print("Provider: ${info.providerId}");
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("uid", userCredential.user!.uid);
        await prefs.setString("email", username.text.trim());
        await prefs.setBool("isLoggedIn", true);

        Get.snackbar("Success", "Login successful");
        Get.offAll(() => HomeMainScreen());
      } else {
        print(" Firebase sign in FAILED: userCredential.user is null");
        Get.snackbar("Error", "Login failed: User not found");
      }

    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException caught");
      print("Code: ${e.code}");
      print("Message: ${e.message}");
      Get.snackbar("Login Error", e.message ?? "Something went wrong");
    } catch (e) {
      print(" Unknown error during login: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
      print("Login() finished");
    }
  }

  void forgotPassword() async {
    final email = username.text.trim();
    print(" forgotPassword() called");
    print(" Email entered: $email");

    if (email.isEmpty) {
      print(" Error: email is empty");
      Get.snackbar("Error", "Please enter your email first");
      return;
    }

    //  ADD: show current Firebase user (usually null)
    print("👤 Current Firebase user: ${_auth.currentUser?.email}");

    try {
      print(" Sending password reset email...");
      await _auth.sendPasswordResetEmail(email: email);

      
      print(" Firebase ACCEPTED reset request");
      print(" Reset email SHOULD be sent to: $email");

      Get.snackbar(
        "Success",
        "Password reset email sent.\nCheck Inbox, Spam, and Promotions.",
      );
    } on FirebaseAuthException catch (e) {
      print(" FirebaseAuthException in forgotPassword");
      print(" Code: ${e.code}");
      print(" Message: ${e.message}");

      if (e.code == 'user-not-found') {
        Get.snackbar("Error", "No account found for this email.");
      } else if (e.code == 'invalid-email') {
        Get.snackbar("Error", "Invalid email format.");
      } else if (e.code == 'too-many-requests') {
        Get.snackbar("Error", "Too many requests. Try again later.");
      } else {
        Get.snackbar("Error", e.message ?? "Failed to send reset email");
      }
    } catch (e) {
      print(" Unknown error in forgotPassword: $e");
      Get.snackbar("Error", "Something went wrong");
    }
  }
  
Future<void> loginWithGoogle() async {
  try {
    isLoading.value = true;
    UserCredential userCredential;

    if (kIsWeb) {
      userCredential = await _auth.signInWithPopup(GoogleAuthProvider());
    } else {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      userCredential = await _auth.signInWithCredential(credential);
    }

    if (userCredential.user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("uid", userCredential.user!.uid);
      await prefs.setString("email", userCredential.user!.email ?? "");
      await prefs.setBool("isLoggedIn", true);

      Get.snackbar("Success", "Logged in with Google");
      Get.offAll(() => HomeMainScreen());
    }

  } catch (e) {
    print(" Google login error: $e");
    Get.snackbar("Error", "Google login failed");
  } finally {
    isLoading.value = false;
  }
}

  @override
  void onClose() {
    print(" Disposing controllers...");
    username.dispose();
    password.dispose();
    super.onClose();
  }
}
