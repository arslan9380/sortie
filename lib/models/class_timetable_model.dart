import 'package:sortie/backend/backend.dart';

class ClassTimeTableModel {
  String uid;
  String day;
  Timestamp startTime;
  Timestamp endTime;
  String roomNo;
  String courseName;
  String instructorName;
  String section;
  String userId;

  ClassTimeTableModel(
      {this.uid,
      this.day,
      this.startTime,
      this.endTime,
      this.roomNo,
      this.courseName,
      this.instructorName,
      this.section,
      this.userId});

  factory ClassTimeTableModel.fromMap(Map<String, dynamic> map) {
    return new ClassTimeTableModel(
      uid: map['uid'] as String,
      day: map['day'] as String,
      startTime: map['startTime'] as Timestamp,
      endTime: map['endTime'] as Timestamp,
      roomNo: map['roomNo'] as String,
      courseName: map['courseName'] as String,
      instructorName: map['instructorName'] as String,
      section: map['section'] as String,
      userId: map['userId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'uid': this.uid,
      'day': this.day,
      'startTime': this.startTime,
      'endTime': this.endTime,
      'roomNo': this.roomNo,
      'courseName': this.courseName,
      'instructorName': this.instructorName,
      'section': this.section,
      'userId': this.userId,
    } as Map<String, dynamic>;
  }
}
