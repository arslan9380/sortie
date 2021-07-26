import 'package:sortie/models/class_timetable_model.dart';

class CourseModel {
  String uid;
  String courseName;
  String instructorName;
  String section;
  String userId;
  List<ClassTimeTableModel> allClasses;

  CourseModel(
      {this.uid,
      this.courseName,
      this.instructorName,
      this.section,
      this.allClasses,
      this.userId});

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return new CourseModel(
        uid: map['uid'] as String,
        courseName: map['courseName'] as String,
        instructorName: map['instructorName'] as String,
        section: map['section'] as String,
        userId: map['userId'] as String,
        allClasses: map['allClasses'].map<ClassTimeTableModel>((item) {
          return ClassTimeTableModel.fromMap(item);
        }).toList());
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'uid': this.uid,
      'courseName': this.courseName,
      'instructorName': this.instructorName,
      'section': this.section,
      'userId': this.userId,
      'allClasses': this.allClasses.map((e) => e.toMap()).toList(),
    } as Map<String, dynamic>;
  }
}
