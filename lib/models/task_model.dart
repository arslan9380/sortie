import 'package:sortie/backend/backend.dart';

class ToDoModel {
  Timestamp toDoDate;
  String toDoDescription;
  String toDoName;
  bool toDoStatus;
  String userId;
  String uid;

  ToDoModel(
      {this.toDoDate,
      this.toDoDescription,
      this.toDoName,
      this.toDoStatus,
      this.userId,
      this.uid});

  factory ToDoModel.fromMap(Map<String, dynamic> map) {
    return new ToDoModel(
      toDoDate: map['toDoDate'] as Timestamp,
      toDoDescription: map['toDoDescription'] as String,
      toDoName: map['toDoName'] as String,
      toDoStatus: map['toDoStatus'] as bool,
      userId: map['userId'] as String,
      uid: map['uid'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'toDoDate': this.toDoDate,
      'toDoDescription': this.toDoDescription,
      'toDoName': this.toDoName,
      'toDoStatus': this.toDoStatus,
      'userId': this.userId,
      'uid': this.uid,
    } as Map<String, dynamic>;
  }
}
