import 'dart:io';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PregramController extends GetxController {
  var posts = <QueryDocumentSnapshot>[].obs;
  var isUploading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔥 STORE CURRENT USERNAME
  var currentUsername = ''.obs;

  @override
  void onInit() {
    super.onInit();

    _loadCurrentUser();

    _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      posts.value = snapshot.docs;
    });
  }

  // 🔥 LOAD USERNAME FROM users/{uid}
  Future<void> _loadCurrentUser() async {
    final user = _auth.currentUser!;
    final doc =
        await _firestore.collection('users').doc(user.uid).get();

    if (doc.exists) {
      currentUsername.value = doc['username'];
    }
  }

  Future<void> uploadPost({
    required String desc,
    File? imageFile,
  }) async {
    if (desc.trim().isEmpty && imageFile == null) return;

    isUploading.value = true;

    final user = _auth.currentUser!;
    final email = user.email!;

    // 🔥 GUARANTEE USERNAME IS READY
    String username = currentUsername.value;
    if (username.isEmpty) {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      username = doc['username'];
      currentUsername.value = username;
    }

    String? imageUrl;

    if (imageFile != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('posts')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }

    await _firestore.collection('posts').add({
      'username': username,
      'email': email,
      'desc': desc,
      'imageUrl': imageUrl,
      'likesCount': 0,
      'commentsCount': 0,
      'timestamp': FieldValue.serverTimestamp(),
    });

    isUploading.value = false;
  }

  Future<void> toggleLike(String postId) async {
    final user = _auth.currentUser!;
    final postRef = _firestore.collection('posts').doc(postId);
    final likeRef = postRef.collection('likes').doc(user.uid);

    final doc = await likeRef.get();
    if (doc.exists) {
      await likeRef.delete();
      await postRef.update({
        'likesCount': FieldValue.increment(-1),
      });
    } else {
      await likeRef.set({'email': user.email});
      await postRef.update({
        'likesCount': FieldValue.increment(1),
      });
    }
  }

  Future<void> toggleFavorite(String postId) async {
    final user = _auth.currentUser!;
    final favRef = _firestore
        .collection('posts')
        .doc(postId)
        .collection('favorites')
        .doc(user.uid);

    final fav = await favRef.get();
    if (fav.exists) {
      await favRef.delete();
    } else {
      await favRef.set({'email': user.email});
    }
  }

  Future<void> addComment(String postId, String text) async {
    if (text.trim().isEmpty) return;

    final user = _auth.currentUser!;
    final email = user.email!;

    // 🔥 GUARANTEE USERNAME FOR COMMENTS TOO
    String username = currentUsername.value;
    if (username.isEmpty) {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      username = doc['username'];
      currentUsername.value = username;
    }

    final ref = _firestore.collection('posts').doc(postId);

    await ref.collection('comments').add({
      'username': username,
      'email': email,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await ref.update({
      'commentsCount': FieldValue.increment(1),
    });
  }
}
