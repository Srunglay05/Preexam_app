import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritePostsScreen extends StatelessWidget {
  FavoritePostsScreen({super.key});

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          'Favorite Posts',
          style: TextStyle(
            fontFamily: 'Teacher',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: posts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final post = posts[index];

              return StreamBuilder<DocumentSnapshot>(
                stream: firestore
                    .collection('posts')
                    .doc(post.id)
                    .collection('favorites')
                    .doc(userId)
                    .snapshots(),
                builder: (context, favSnapshot) {
                  if (!favSnapshot.hasData ||
                      !favSnapshot.data!.exists) {
                    return const SizedBox();
                  }

                  final data = post.data() as Map<String, dynamic>;

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

                        // 👤 PROFILE HEADER
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 22,
                                backgroundImage: AssetImage(
                                  'assets/images/timee.png',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['username'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Teacher',
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

                        // 📝 POST TEXT
                        if ((data['desc'] ?? '')
                            .toString()
                            .isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            child: Text(
                              data['desc'],
                              style: const TextStyle(
                                fontFamily: 'Teacher',
                                fontSize: 15,
                                height: 1.4,
                              ),
                            ),
                          ),

                        // 🖼 POST IMAGE
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
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
