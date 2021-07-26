import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sortie/models/course_model.dart';

class CourseService {
  String courseCollection = "AllCourses";

  Future<String> saveCourse(CourseModel courseModel) async {
    try {
      await FirebaseFirestore.instance
          .collection(courseCollection)
          .doc(courseModel.uid)
          .set(courseModel.toMap(), SetOptions(merge: true));
      return "success";
    } catch (e) {
      print("Error: $e");
      return "fail";
    }
  }

  Future<List<CourseModel>> getPostByUid() async {
    String id = FirebaseAuth.instance.currentUser.uid;
    List<CourseModel> allCourses = [];
    try {
      var result = await FirebaseFirestore.instance
          .collection(courseCollection)
          .where("userId", isEqualTo: id)
          .get();
      for (var doc in result.docs) {
        allCourses.add(CourseModel.fromMap(doc.data()));
      }
      return allCourses;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
