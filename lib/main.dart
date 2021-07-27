import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sortie/homepage/homepage_widget.dart';
import 'package:sortie/services/get_controller.dart';
import 'package:sortie/services/notification_service.dart';
import 'package:sortie/splash_screen/splash_screen_widget.dart';

import 'auth/firebase_user_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

AndroidNotificationChannel alarmChannel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
  // sound: RawResourceAndroidNotificationSound("alarm_sound"),
  // playSound: true,
  // groupId: "alarm",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(alarmChannel);

  initNotification();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Stream<SortieFirebaseUser> userStream;
  SortieFirebaseUser initialUser;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    userStream = sortieFirebaseUserStream()
      ..listen((user) => initialUser ?? setState(() => initialUser = user));
    // handleNotification();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sortie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: initialUser == null
          ? Center(
              child: Builder(
                builder: (context) => Image.asset(
                  'assets/images/todo_0.0_Splash@3x.png',
                  width: MediaQuery.of(context).size.width / 2,
                  fit: BoxFit.fitWidth,
                ),
              ),
            )
          : currentUser.loggedIn
              ? HomepageWidget()
              //MyTasksWidget()
              : SplashScreenWidget(),
    );
  }
}

Future<void> initNotification() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid =
      AndroidInitializationSettings("@mipmap/ic_launcher");
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (payload) async {
    return;
  });
  // handleNotification();
}

Future<void> handleNotification() async {
  _showNotification("its title", "its body");
}

Future<void> _showNotification(String title, String body) async {
  DateTime dateTime = DateTime.now().add(Duration(seconds: 5));

  Get.put(MyController());
  await Future.delayed(Duration(seconds: 3));

  NotificationService().showNotification(title, body, dateTime, "Tuesday");
  NotificationService()
      .showNotification(title, body, dateTime, "Tuesday", isAlarm: true);
  // NotificationService().showNotification(
  //   title,
  //   body,
  //   DateTime.now().add(Duration(seconds: 15)),
  //   "Tuesday",
  // );

  // tz.setLocalLocation(tz.getLocation());
  // var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //   'your channel id', 'your channel name', 'your channel description',
  //   importance: Importance.max,
  //   priority: Priority.high,
  //   enableVibration: true,
  //   //fullScreenIntent: true,
  //   // playSound: true,
  //   // sound: RawResourceAndroidNotificationSound("alarm_sound"),
  //   ticker: 'ticker',
  //   // additionalFlags: Int32List.fromList(<int>[4])
  // );
  // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  // var platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //     iOS: iOSPlatformChannelSpecifics);

  // await flutterLocalNotificationsPlugin
  //     .show(0, title, body, platformChannelSpecifics, payload: 'item x');
  // Time notificationTime = Time(17, 22);
  // Day day = Day(DateTime.sunday);
  // flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
  //     0, "schedule", body, day, notificationTime, platformChannelSpecifics);

  // await flutterLocalNotificationsPlugin.zonedSchedule(
  //     887788,
  //     "Welcome Back.",
  //     "Its a test alarm just pull down the bar",
  //     tz.TZDateTime.now(tz.local).add(Duration(seconds: 2)),
  //     platformChannelSpecifics,
  //     matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
  //     uiLocalNotificationDateInterpretation:
  //     UILocalNotificationDateInterpretation.absoluteTime,
  //     androidAllowWhileIdle: true);
}
