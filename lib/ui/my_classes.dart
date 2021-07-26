import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sortie/flutter_flow/flutter_flow_theme.dart';
import 'package:sortie/services/get_controller.dart';
import 'package:sortie/ui/add_class.dart';

class MyClasses extends StatefulWidget {
  @override
  _MyClassesState createState() => _MyClassesState();
}

class _MyClassesState extends State<MyClasses> {
  MyController myController = Get.find<MyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Classes"),
        centerTitle: true,
        backgroundColor: FlutterFlowTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () => myController.allCourses.length == 0
                  ? Container(
                      margin: EdgeInsets.only(top: Get.height * 0.4),
                      child: Center(
                          child: Text(
                        "No Class Added Yet",
                        style: TextStyle(color: Colors.black),
                      )))
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: myController.allCourses.length,
                      itemBuilder: (_, i) {
                        return Column(children: [
                          Container(
                            color: Colors.green,
                            width: Get.width,
                            margin: EdgeInsets.only(
                                right: Get.width * 0.35, top: 16),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Course Name: ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      myController.allCourses[i].courseName,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Instructor Name: ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      myController.allCourses[i].instructorName,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                              itemCount:
                                  myController.allCourses[i].allClasses.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (_, index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      top: 20, left: 16, right: 16),
                                  padding: EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width,
                                  color: FlutterFlowTheme.secondaryColor,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Day: ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            myController.allCourses[i]
                                                .allClasses[index].day,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Room No: ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            myController.allCourses[i]
                                                .allClasses[index].roomNo,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Start Time: ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            DateFormat("hh:mm a").format(
                                                myController.allCourses[i]
                                                    .allClasses[index].startTime
                                                    .toDate()),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "End Time: ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            DateFormat("hh:mm a").format(
                                                myController.allCourses[i]
                                                    .allClasses[index].endTime
                                                    .toDate()),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          SizedBox(
                            height: 20,
                          )
                        ]);
                      }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddClass()));
        },
        backgroundColor: FlutterFlowTheme.primaryColor,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
