import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sortie/models/task_model.dart';
import 'package:sortie/services/get_controller.dart';
import 'package:sortie/services/to_do_service.dart';

import '../create_task_page/create_task_page_widget.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_toggle_icon.dart';
import '../flutter_flow/flutter_flow_util.dart';

class MyTasksWidget extends StatefulWidget {
  MyTasksWidget({Key key}) : super(key: key);

  @override
  _MyTasksWidgetState createState() => _MyTasksWidgetState();
}

class _MyTasksWidgetState extends State<MyTasksWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  MyController myController = Get.find<MyController>();
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          'My Tasks',
          style: FlutterFlowTheme.title1.override(
            fontFamily: 'Lexend Deca',
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: FlutterFlowTheme.darkBG,
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.bottomToTop,
                duration: Duration(milliseconds: 270),
                reverseDuration: Duration(milliseconds: 270),
                child: CreateTaskPageWidget(),
              ),
            );
          },
          backgroundColor: FlutterFlowTheme.primaryColor,
          elevation: 8,
          child: Icon(
            Icons.add_rounded,
            color: FlutterFlowTheme.white,
            size: 30,
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 53,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.darkBG,
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: Image.asset(
                          'assets/images/waves@2x.png',
                        ).image,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          tab = 0;
                        });
                      },
                      child: Container(
                        height: 50,
                        width: Get.width * 0.4,
                        decoration: BoxDecoration(
                            color: tab == 0
                                ? FlutterFlowTheme.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: FlutterFlowTheme.primaryColor)),
                        child: Center(
                            child: Text(
                          "PENDING TASKS",
                          style: TextStyle(
                              color: tab == 0 ? Colors.white : Colors.black,
                              fontSize: 12),
                        )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          tab = 1;
                        });
                      },
                      child: Container(
                        height: 50,
                        width: Get.width * 0.4,
                        decoration: BoxDecoration(
                            color: tab == 1
                                ? FlutterFlowTheme.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: FlutterFlowTheme.primaryColor)),
                        child: Center(
                            child: Text(
                          "COMPLETED TASKS",
                          style: TextStyle(
                              color: tab == 1 ? Colors.white : Colors.black,
                              fontSize: 12),
                        )),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Obx(
                () => ListView.builder(
                    itemCount: myController.allToDos.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      bool status = false;
                      if (tab == 0) {
                        status = false;
                      } else {
                        status = true;
                      }
                      return myController.allToDos[index].toDoStatus == status
                          ? Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Material(
                                color: Colors.transparent,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.primaryColor
                                        .withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(16, 0, 0, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                myController
                                                    .allToDos[index].toDoName,
                                                style: FlutterFlowTheme.title2
                                                    .override(
                                                  fontFamily: 'Lexend Deca',
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 4, 0, 0),
                                                child: Text(
                                                  dateTimeFormat(
                                                      'MMMEd',
                                                      myController
                                                          .allToDos[index]
                                                          .toDoDate
                                                          .toDate()),
                                                  style: FlutterFlowTheme
                                                      .bodyText2
                                                      .override(
                                                    fontFamily: 'Lexend Deca',
                                                    color: FlutterFlowTheme
                                                        .primaryColor,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 12, 0),
                                            child: ToggleIcon(
                                              onPressed: () async {
                                                myController.allToDos[index]
                                                        .toDoStatus =
                                                    !myController
                                                        .allToDos[index]
                                                        .toDoStatus;
                                                setState(() {});
                                                if (myController.allToDos[index]
                                                    .toDoStatus) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Added to Completed TODO");
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Added to Pending TODO");
                                                }
                                                updateStatus(
                                                    myController
                                                        .allToDos[index],
                                                    myController.allToDos[index]
                                                        .toDoStatus);
                                              },
                                              value: myController
                                                  .allToDos[index].toDoStatus,
                                              onIcon: Icon(
                                                Icons.check_circle,
                                                color: FlutterFlowTheme
                                                    .primaryColor,
                                                size: 25,
                                              ),
                                              offIcon: Icon(
                                                Icons.radio_button_off,
                                                color: Color(0xFF2B343A),
                                                size: 25,
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateStatus(ToDoModel toDoModel, bool toDoStatus) {
    ToDoService().updateToDoStatus(toDoModel, toDoStatus);
  }
}
