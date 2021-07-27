import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sortie/services/get_controller.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  Future showNotification(
      String title, String body, DateTime scheduleTime, String day,
      {bool isAlarm = false}) async {
    tz.initializeTimeZones();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    int i;
    if (isAlarm) {
      Get.find<MyController>().alarmNumber =
          Get.find<MyController>().alarmNumber + 1;
      i = Get.find<MyController>().alarmNumber;
    } else {
      Get.find<MyController>().notificationNumber =
          Get.find<MyController>().notificationNumber + 1;
      i = Get.find<MyController>().notificationNumber;
    }
    print(makeCorrectDate(scheduleTime, day));
    print("Schedule at:" +
        tz.TZDateTime.from(makeCorrectDate(scheduleTime, day), tz.local)
            .toString() +
        " id: " +
        i.toString());

    var androidPlatformChannelSpecificsAlarm = AndroidNotificationDetails(
      'alarm Id',
      'alarm name',
      'alarm description',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
      enableLights: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("alarm_sound"),
      additionalFlags: Int32List.fromList(<int>[4]),
      ticker: 'ticker',
    );

    var androidPlatformChannelSpecificsNotification =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.max,
      enableVibration: true,
      ticker: 'ticker',
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: isAlarm
            ? androidPlatformChannelSpecificsAlarm
            : androidPlatformChannelSpecificsNotification,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        i,
        isAlarm ? "Alarm" : title,
        body,
        tz.TZDateTime.from(makeCorrectDate(scheduleTime, day), tz.local),
        platformChannelSpecifics,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  DateTime makeCorrectDate(DateTime dateTime, String day) {
    DateTime correctDate = dateTime;
    DateTime currentTime = dateTime;
    int dayNo = intFromDay(day);
    if (currentTime.weekday != dayNo) {
      correctDate = currentTime.add(Duration(days: dayNo));
    }
    return correctDate;
  }

  int intFromDay(String day) {
    if (day == "Monday") {
      return 1;
    } else if (day == "Tuesday") {
      return 2;
    } else if (day == "Wednesday") {
      return 3;
    } else if (day == "Thursday") {
      return 4;
    } else if (day == "Friday") {
      return 5;
    } else if (day == "Saturday") {
      return 6;
    } else if (day == "Sunday") {
      return 7;
    }
    return 0;
  }
}
