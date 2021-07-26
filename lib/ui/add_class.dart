import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sortie/flutter_flow/flutter_flow_theme.dart';
import 'package:sortie/models/class_timetable_model.dart';
import 'package:sortie/models/course_model.dart';
import 'package:sortie/services/course_service.dart';
import 'package:sortie/services/get_controller.dart';
import 'package:sortie/services/notification_service.dart';
import 'package:sortie/services/shared_pref_service.dart';
import 'package:sortie/ui/add_timetable.dart';
import 'package:sortie/widgets/inputfield_widget.dart';

class AddClass extends StatefulWidget {
  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  List<ClassTimeTableModel> addedTimeTable = [];
  TextEditingController subjNameCon = TextEditingController();
  TextEditingController instructorNameCon = TextEditingController();
  TextEditingController sectionNameCon = TextEditingController();
  bool showLoading = false;

  MyController myController = Get.find<MyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add class"),
        centerTitle: true,
        backgroundColor: FlutterFlowTheme.primaryColor,
        actions: [
          InkWell(
            onTap: saveSubject,
            child: Container(
                margin: EdgeInsets.only(right: 12),
                child: Center(child: Text("Save"))),
          )
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: showLoading,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                InputFieldWidget(
                  hint: "Subject Name",
                  controller: subjNameCon,
                ),
                SizedBox(
                  height: 12,
                ),
                InputFieldWidget(
                  hint: "Instructor Name",
                  controller: instructorNameCon,
                ),
                SizedBox(
                  height: 12,
                ),
                InputFieldWidget(
                  hint: "Section Name",
                  controller: sectionNameCon,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: Get.width,
                  constraints: BoxConstraints(minHeight: 300),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: FlutterFlowTheme.primaryColor)),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        alignment: Alignment.centerLeft,
                        color: FlutterFlowTheme.primaryColor.withOpacity(0.5),
                        child: Center(
                          child: Text(
                            "Added Classes",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      addedTimeTable.length == 0
                          ? Container(
                              margin: EdgeInsets.only(top: 100),
                              child: Text("No any timetable added yet"))
                          : ListView.builder(
                              itemCount: addedTimeTable.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (_, index) {
                                return Container(
                                  margin: EdgeInsets.only(top: 20),
                                  padding: EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width,
                                  color: FlutterFlowTheme.primaryColor
                                      .withOpacity(0.2),
                                  child: Column(
                                    children: [
                                      Text(addedTimeTable[index].day),
                                      Text(addedTimeTable[index].roomNo),
                                    ],
                                  ),
                                );
                              })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTimeTable()));
          if (result != null) {
            addedTimeTable.add(result);
            setState(() {});
          }
        },
        backgroundColor: FlutterFlowTheme.primaryColor,
        child: Icon(Icons.add),
      ),
    );
  }

  saveSubject() async {
    if (subjNameCon.text.isEmpty ||
        instructorNameCon.text.isEmpty ||
        sectionNameCon.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all the fields");
      return;
    }
    if (addedTimeTable.length == 0) {
      Fluttertoast.showToast(msg: "Please add at least one class.");
      return;
    }
    addedTimeTable.forEach((element) {
      element.instructorName = instructorNameCon.text;
      element.courseName = subjNameCon.text;
      element.section = sectionNameCon.text;
    });
    CourseModel courseModel = CourseModel(
      uid: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: FirebaseAuth.instance.currentUser.uid,
      allClasses: addedTimeTable,
      courseName: subjNameCon.text,
      instructorName: instructorNameCon.text,
      section: sectionNameCon.text,
    );
    setState(() {
      showLoading = true;
    });
    var result = await CourseService().saveCourse(courseModel);
    if (result == "success") {
      if (myController.isNotificationOn) {
        addedTimeTable.forEach((element) async {
          DateTime scheduleTime = element.startTime.toDate().subtract(
              Duration(minutes: int.parse(myController.notificationTime)));

          await NotificationService().showNotification(
              element.courseName,
              "You have a class in ${myController.notificationTime} minutes at ${element.roomNo} conducted by ${element.instructorName}",
              scheduleTime,
              element.day);
        });

        PrefServices().saveIntValue(
            "notificationNumber", myController.notificationNumber);
      }

      myController.allCourses.add(courseModel);
    }
    setState(() {
      showLoading = false;
    });
    Get.back();
  }
}
