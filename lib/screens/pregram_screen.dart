import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pregram_controller.dart';

class PregramScreen extends StatelessWidget {
  const PregramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PregramController());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        automaticallyImplyLeading: false, // ❌ REMOVE BACK ARROW
        title: const Text(
          'Pregram',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Teacher', // 👈 Teacher font
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.posts.length,
          itemBuilder: (context, index) {
            final post = controller.posts[index];
            return _postCard(post);
          },
        ),
      ),
    );
  }

  Widget _postCard(Map post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // shadow color
            spreadRadius: 2, // how much the shadow spreads
            blurRadius: 7, // how soft the shadow is
            offset: const Offset(0, 3), // x and y offset
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// PROFILE
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Teacher',
                    ),
                  ),
                  Text(
                    post['username'],
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: 'Teacher',
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// DESCRIPTION
          Text(
            post['desc'],
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Teacher',
            ),
          ),

          const SizedBox(height: 10),

          /// IMAGE CARD
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              post['image'],
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 10),

          /// ACTION ICONS
          Row(
            children: const [
              Icon(Icons.favorite_border, size: 23),
              SizedBox(width: 15),
              Icon(Icons.chat_bubble_outline, size: 22),
              SizedBox(width: 15),
              Icon(Icons.share_outlined, size: 22),
            ],
          ),
        ],
      ),
    );
  }
}
