import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskController extends GetxController {
  // Reactive list of tasks
  var tasks = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  void fetchTasks() {
    FirebaseFirestore.instance
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      tasks.value = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<void> addTask(Map<String, dynamic> taskData) async {
    await FirebaseFirestore.instance.collection('tasks').add(taskData);
  }
}
