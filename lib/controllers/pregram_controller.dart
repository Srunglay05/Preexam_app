import 'package:get/get.dart';

class PregramController extends GetxController {
  final posts = <Map<String, dynamic>>[
    {
      'name': 'Neasa',
      'username': '@neasa7896',
      'desc':
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      'image': 'assets/images/Dr.png',
      'isLiked': false.obs, // ✅ MUST be RxBool
    },
    {
      'name': 'Neasa',
      'username': '@neasa7896',
      'desc':
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      'image': 'assets/images/Dr.png',
      'isLiked': false.obs,
    },
  ].obs;

  void toggleLike(int index) {
    final RxBool isLiked = posts[index]['isLiked'];
    isLiked.value = !isLiked.value;
  }
}
