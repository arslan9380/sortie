import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sortie/models/course_model.dart';
import 'package:sortie/models/task_model.dart';
import 'package:sortie/services/course_service.dart';
import 'package:sortie/services/shared_pref_service.dart';
import 'package:sortie/services/to_do_service.dart';

class MyController extends GetxController {
  var allCourses = <CourseModel>[].obs;
  var allToDos = <ToDoModel>[].obs;
  bool isNotificationOn = true;
  bool isAlarmOn = false;

  String notificationTime = "5";
  String alarmTime = "5";

  int notificationNumber = 120;
  int initialNotificationNumber = 120;
  int alarmNumber = 0;
  int initialAlarmNumber = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void onInit() {
    if (FirebaseAuth.instance?.currentUser?.uid != null) {
      CourseService().getPostByUid().then((value) {
        if (value != null) {
          allCourses.addAll(value);
          print("length" + allCourses.length.toString());
        }
      });

      ToDoService().getAllToDos().then((value) {
        if (value != null) {
          allToDos.addAll(value);
          print("length" + allToDos.length.toString());
        }
      });
    }

    PrefServices().getBoolValue("notificationStatus").then((value) {
      if (value != null) {
        isNotificationOn = value;
      }
    });
    PrefServices().getBoolValue("alarmStatus").then((value) {
      if (value != null) {
        isAlarmOn = value;
      }
    });
    PrefServices().getStringValue("notificationTime").then((value) {
      if (value != null) {
        notificationTime = value;
      }
    });

    PrefServices().getStringValue("alarmTime").then((value) {
      if (value != null) {
        alarmTime = value;
      }
    });

    PrefServices().getIntValue("notificationNumber").then((value) {
      if (value != null) {
        notificationNumber = value;
      }
    });
    PrefServices().getIntValue("alarmNumber").then((value) {
      if (value != null) {
        alarmNumber = value;
      }
    });
    super.onInit();
  }
}
