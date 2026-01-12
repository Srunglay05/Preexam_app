import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../controllers/pregram_controller.dart';
import '../screens/comments_screen.dart';
import '../screens/favorite_posts_screen.dart';

class PregramScreen extends StatelessWidget {
  const PregramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PregramController());
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),

      // 🔝 APP BAR
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Pregram',
          style: TextStyle(
            fontFamily: 'Teacher',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Get.to(() => FavoritePostsScreen());
            },
          ),
        ],
      ),

      // ➕ ADD POST
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => _showAddPostDialog(controller),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      // 📃 POSTS LIST
      body: Obx(() {
        if (controller.posts.isEmpty) {
          return const Center(child: Text('No posts yet'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(14),
          itemCount: controller.posts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final post = controller.posts[index];
            final data = post.data() as Map<String, dynamic>;
            return _postCard(controller, post.id, data, user.uid);
          },
        );
      }),
    );
  }

  // 🧱 POST CARD
  Widget _postCard(
    PregramController controller,
    String postId,
    Map data,
    String userId,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 👤 USER HEADER
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundImage:
                      AssetImage('assets/images/timee.png'),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['username'] ?? '',
                      style: const TextStyle(
                        fontFamily: 'Teacher',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      data['email'] ?? '',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 📝 TEXT
          if ((data['desc'] ?? '').toString().isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                data['desc'],
                style: const TextStyle(
                  fontFamily: 'Teacher',
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),

          // 🖼 IMAGE
          if (data['imageUrl'] != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(18),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  data['imageUrl'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],

          // ❤️ 💬 ⭐ ACTION ROW
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [

                // ❤️ LIKE
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .collection('likes')
                      .doc(userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final isLiked =
                        snapshot.data?.exists ?? false;

                    return IconButton(
                      icon: Icon(
                        isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            isLiked ? Colors.red : Colors.grey,
                      ),
                      onPressed: () =>
                          controller.toggleLike(postId),
                    );
                  },
                ),
                Text('${data['likesCount'] ?? 0}'),

                const SizedBox(width: 12),

                // 💬 COMMENT
                IconButton(
                  icon:
                      const Icon(Icons.chat_bubble_outline),
                  onPressed: () =>
                      _showCommentDialog(controller, postId),
                ),
                Text('${data['commentsCount'] ?? 0}'),

                const SizedBox(width: 6),

                // 👇 VIEW ALL (RESTORED)
                GestureDetector(
                  onTap: () {
                    Get.to(() =>
                        CommentsScreen(postId: postId));
                  },
                  child: const Text(
                    'View all',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Teacher',
                    ),
                  ),
                ),

                const Spacer(),

                // ⭐ FAVORITE
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .collection('favorites')
                      .doc(userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final isFav =
                        snapshot.data?.exists ?? false;

                    return IconButton(
                      icon: Icon(
                        isFav
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: isFav
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      onPressed: () =>
                          controller.toggleFavorite(postId),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ➕ ADD POST (NO OVERFLOW)
  void _showAddPostDialog(PregramController controller) {
    final TextEditingController textController =
        TextEditingController();
    File? image;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        const Text(
                          'Create Post',
                          style: TextStyle(
                            fontFamily: 'Teacher',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        TextField(
                          controller: textController,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: "What's on your mind?",
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        if (image != null) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.file(
                              image!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.photo_library,
                                color: Colors.green,
                              ),
                              onPressed: () async {
                                final picked =
                                    await ImagePicker().pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (picked != null) {
                                  setState(() {
                                    image = File(picked.path);
                                  });
                                }
                              },
                            ),
                            const Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                controller.uploadPost(
                                  desc: textController.text,
                                  imageFile: image,
                                );
                                Get.back();
                              },
                              child: const Text(
                                'Post',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Teacher',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  // 💬 ADD COMMENT (MODERN)
  void _showCommentDialog(
      PregramController controller, String postId) {
    final TextEditingController textController =
        TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                'Add Comment',
                style: TextStyle(
                  fontFamily: 'Teacher',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: textController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      controller.addComment(
                        postId,
                        textController.text,
                      );
                      Get.back();
                    },
                    child: const Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Teacher',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
