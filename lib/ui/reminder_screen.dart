import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sortie/flutter_flow/flutter_flow_theme.dart';
import 'package:sortie/models/class_timetable_model.dart';
import 'package:sortie/services/get_controller.dart';
import 'package:sortie/services/notification_service.dart';
import 'package:sortie/services/shared_pref_service.dart';
import 'package:sortie/widgets/expandable_box.dart';
import 'package:sortie/widgets/filter_option_widget.dart';
import 'package:sortie/widgets/inputfield_widget.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool isReminderOn = true;
  bool expandRemindOption = false;
  bool isTaskRemindOn = false;
  bool expandTaskRemind = false;

  int selectedTaskRemind = 5;
  TextEditingController taskRemindCon = TextEditingController();
  List<int> taskList = [5, 6, 7, 8];

  bool expandAlarm = false;
  bool alarmSwitch = false;
  int alarm = 5;
  TextEditingController alarmCon = TextEditingController();
  List<int> alarmList = [5, 15, 30, 45, 60, 90, 120];

  int selectedTime = 15;
  TextEditingController remindCon = TextEditingController();
  List<int> timeList = [5, 15, 30, 45, 60];

  MyController myController = Get.put(MyController());
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool isLoading = false;

  @override
  void initState() {
    if (myController.notificationTime != "") {
      selectedTime = int.parse(myController.notificationTime);
    }

    remindCon.text = "Remind me " + selectedTime.toString() + " minutes before";
    isReminderOn = myController.isNotificationOn;
    alarmSwitch = myController.isAlarmOn;
    taskRemindCon.text = "At " +
        selectedTaskRemind.toString() +
        ":00 PM the day before the task is due";
    alarmCon.text =
        "Ring Alarm " + alarm.toString() + " minutes before my first class";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reminders"),
        backgroundColor: FlutterFlowTheme.primaryColor,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: setNotifications,
            child: Container(
                margin: EdgeInsets.only(right: 12),
                child: Center(child: Text("Save"))),
          )
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
              height: 60,
              color: FlutterFlowTheme.primaryColor.withOpacity(0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isReminderOn ? "On" : "Off",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  CupertinoSwitch(
                      value: isReminderOn,
                      onChanged: (val) {
                        setState(() {
                          isReminderOn = val;
                          myController.isNotificationOn = val;
                          PrefServices()
                              .saveBoolValue("notificationStatus", val);
                        });
                      })
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Class reminders",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        expandRemindOption = !expandRemindOption;
                      });
                    },
                    child: InputFieldWidget(
                      enable: false,
                      showDropDown: true,
                      controller: remindCon,
                    ),
                  ),
                  if (expandRemindOption == true)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                        ),
                        color: const Color(0xffffffff),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(0, 6),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: ExpandedSection(
                        expand: expandRemindOption,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5.0),
                                bottomLeft: Radius.circular(5.0),
                              ),
                              color: const Color(0xffffffff),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x29000000),
                                  offset: Offset(0, 6),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: ListView.builder(
                                itemCount: timeList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (_, index) {
                                  return InkWell(
                                    onTap: () {
                                      expandRemindOption = false;
                                      selectedTime = timeList[index];
                                      remindCon.text = "Remind me " +
                                          selectedTime.toString() +
                                          " minutes before";
                                      myController.notificationTime =
                                          selectedTime.toString();
                                      PrefServices().saveStringValue(
                                          "notificationTime",
                                          selectedTime.toString());
                                      setState(() {});
                                    },
                                    child: FilterOptionWidget(
                                      title: "Remind me " +
                                          timeList[index].toString() +
                                          " minutes before",
                                      selectedValue: "Remind me " +
                                          selectedTime.toString() +
                                          " minutes before",
                                    ),
                                  );
                                })),
                      ),
                    ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Alarm Notification",
                    style: TextStyle(
                        color: FlutterFlowTheme.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          alarmSwitch ? "On" : "Off",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        CupertinoSwitch(
                            value: alarmSwitch,
                            onChanged: (val) {
                              setState(() {
                                alarmSwitch = val;
                              });
                              myController.isAlarmOn = val;
                              PrefServices().saveBoolValue("alarmStatus", val);
                            })
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        expandAlarm = !expandAlarm;
                      });
                    },
                    child: InputFieldWidget(
                      enable: false,
                      showDropDown: true,
                      controller: alarmCon,
                    ),
                  ),
                  if (expandAlarm == true)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                        ),
                        color: const Color(0xffffffff),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(0, 6),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: ExpandedSection(
                        expand: expandAlarm,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5.0),
                                bottomLeft: Radius.circular(5.0),
                              ),
                              color: const Color(0xffffffff),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x29000000),
                                  offset: Offset(0, 6),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: ListView.builder(
                                itemCount: alarmList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (_, index) {
                                  return InkWell(
                                    onTap: () {
                                      expandAlarm = false;
                                      alarm = alarmList[index];
                                      alarmCon.text = "Ring Alarm " +
                                          alarm.toString() +
                                          " minutes before my first class";
                                      setState(() {});
                                    },
                                    child: FilterOptionWidget(
                                      title: "Ring Alarm " +
                                          alarmList[index].toString() +
                                          " minutes before my first class",
                                      selectedValue: "Ring Alarm " +
                                          alarm.toString() +
                                          " minutes before my first class",
                                    ),
                                  );
                                })),
                      ),
                    ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Task Reminders",
                    style: TextStyle(
                        color: FlutterFlowTheme.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isTaskRemindOn ? "On" : "Off",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        CupertinoSwitch(
                            value: isTaskRemindOn,
                            onChanged: (val) {
                              setState(() {
                                isTaskRemindOn = val;
                              });
                            })
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Remind me about incomplete task",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        expandTaskRemind = !expandTaskRemind;
                      });
                    },
                    child: InputFieldWidget(
                      enable: false,
                      showDropDown: true,
                      controller: taskRemindCon,
                    ),
                  ),
                  if (expandTaskRemind == true)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                        ),
                        color: const Color(0xffffffff),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(0, 6),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: ExpandedSection(
                        expand: expandTaskRemind,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5.0),
                                bottomLeft: Radius.circular(5.0),
                              ),
                              color: const Color(0xffffffff),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x29000000),
                                  offset: Offset(0, 6),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: ListView.builder(
                                itemCount: taskList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (_, index) {
                                  return InkWell(
                                    onTap: () {
                                      expandRemindOption = false;
                                      selectedTaskRemind = taskList[index];
                                      taskRemindCon.text = "At " +
                                          selectedTaskRemind.toString() +
                                          ":00 PM the day before the task is due";
                                      setState(() {});
                                    },
                                    child: FilterOptionWidget(
                                      title: "At " +
                                          taskList[index].toString() +
                                          ":00 PM the day before the task is due",
                                      selectedValue: "At " +
                                          selectedTaskRemind.toString() +
                                          ":00 PM the day before the task is due",
                                    ),
                                  );
                                })),
                      ),
                    ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  Future<void> setNotifications() async {
    setState(() {
      isLoading = true;
    });
    if (isReminderOn) {
      await clearOldScheduleNotifications();
      for (int i = 0; i < myController.allCourses.length; i++) {
        for (int j = 0; j < myController.allCourses[i].allClasses.length; j++) {
          ClassTimeTableModel element =
              myController.allCourses[i].allClasses[j];
          DateTime scheduleTime = element.startTime
              .toDate()
              .subtract(Duration(minutes: selectedTime));
          await NotificationService().showNotification(
              element.courseName,
              "You have a class in $selectedTime minutes at ${element.roomNo} conducted by ${element.instructorName}",
              scheduleTime,
              element.day);
        }
      }

      PrefServices()
          .saveIntValue("notificationNumber", myController.notificationNumber);
    } else {
      clearOldScheduleNotifications();
      PrefServices().saveIntValue(
          "notificationNumber", myController.initialNotificationNumber);
    }

    if (alarmSwitch) {
      clearAlarmNotification();
      List<String> daysList = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday"
      ];
      List<ClassTimeTableModel> allClasses = [];
      myController.allCourses.forEach((course) {
        course.allClasses.forEach((element) {
          allClasses.add(element);
        });
      });
      daysList.forEach((day) async {
        List<ClassTimeTableModel> daySpecificClasses =
            allClasses.where((element) => element.day == day).toList();

        if (daySpecificClasses.length > 0) {
          daySpecificClasses.sort((a, b) => DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  a.startTime.toDate().hour,
                  a.startTime.toDate().minute)
              .compareTo(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  b.startTime.toDate().hour,
                  b.startTime.toDate().minute)));
          DateTime scheduleTime = daySpecificClasses[0]
              .startTime
              .toDate()
              .subtract(Duration(minutes: alarm));
          await NotificationService().showNotification(
              daySpecificClasses[0].courseName,
              "You have a class in $selectedTime minutes at ${daySpecificClasses[0].roomNo} conducted by ${daySpecificClasses[0].instructorName}",
              scheduleTime,
              daySpecificClasses[0].day,
              isAlarm: true);
        }
      });
      PrefServices().saveIntValue("alarmNumber", myController.alarmNumber);
    } else {
      clearAlarmNotification();
      PrefServices().saveIntValue("alarmNumber", 0);
    }
    Future.delayed(Duration(seconds: 1));
    Fluttertoast.showToast(msg: "Saved Successfully");
    setState(() {
      isLoading = false;
    });
    Get.back();
  }

  Future clearOldScheduleNotifications() async {
    for (int i = myController.initialNotificationNumber;
        i < myController.notificationNumber + 1;
        i++) {
      print("Clear notification of $i");

      await flutterLocalNotificationsPlugin.cancel(i);
    }
    myController.notificationNumber = myController.initialNotificationNumber;
  }

  void clearAlarmNotification() {
    for (int i = 0; i < myController.alarmNumber + 1; i++) {
      print("Clear alarm of $i");
      flutterLocalNotificationsPlugin.cancel(i);
    }
    myController.alarmNumber = 0;
  }
}
