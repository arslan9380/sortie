import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sortie/models/task_model.dart';

class ToDoService {
  String toDoCollection = "ToDoList";

  Future<String> saveToDo(ToDoModel toDoModel) async {
    try {
      await FirebaseFirestore.instance
          .collection(toDoCollection)
          .doc(toDoModel.uid)
          .set(toDoModel.toMap(), SetOptions(merge: true));
      return "success";
    } catch (e) {
      print("Error: $e");
      return "fail";
    }
  }

  Future<List<ToDoModel>> getAllToDos() async {
    String id = FirebaseAuth.instance.currentUser.uid;
    List<ToDoModel> allToDos = [];
    try {
      var result = await FirebaseFirestore.instance
          .collection(toDoCollection)
          .where("userId", isEqualTo: id)
          .get();
      for (var doc in result.docs) {
        allToDos.add(ToDoModel.fromMap(doc.data()));
      }
      return allToDos;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<String> updateToDoStatus(ToDoModel toDoModel, bool value) async {
    try {
      await FirebaseFirestore.instance
          .collection(toDoCollection)
          .doc(toDoModel.uid)
          .set({
        "toDoStatus": value,
      }, SetOptions(merge: true));
      return "success";
    } catch (e) {
      print("Error: $e");
      return "fail";
    }
  }
}
