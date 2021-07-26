import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sortie/dashboard/custom_divider.dart';
import 'package:sortie/models/class_timetable_model.dart';
import 'package:sortie/models/task_model.dart';
import 'package:sortie/services/get_controller.dart';

import '../flutter_flow/flutter_flow_theme.dart';

class DashboardWidget extends StatefulWidget {
  DashboardWidget({Key key}) : super(key: key);

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  DateTimeRange calendarSelectedDay;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  EventList<Event> _markedDateMap = new EventList<Event>();
  DateTime selectedDate = DateTime.now();
  MyController myController = Get.find<MyController>();
  List<ClassTimeTableModel> dateSpecificClasses = [];
  List<ToDoModel> pendingToDos = [];
  List<ToDoModel> dateSpecificToDos = [];

  @override
  void initState() {
    pendingToDos = myController.allToDos
        .where((element) => element.toDoStatus == false)
        .toList();
    markedDates(selectedDate);
    getAppointmentsOnSelectedDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.primaryColor,
        automaticallyImplyLeading: true,
        title: Text("Dashboard"),
        actions: [],
        centerTitle: true,
        elevation: 4,
      ),
      //   backgroundColor: FlutterFlowTheme.darkBG,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: Get.width,
                height: Get.height * 0.53,
                child: CalendarCarousel<Event>(
                  customGridViewPhysics: NeverScrollableScrollPhysics(),
                  isScrollable: false,
                  onDayPressed: (DateTime date, List<Event> events) =>
                      setState(() {
                    selectedDate = date;
                    getAppointmentsOnSelectedDate();
                  }),
                  onCalendarChanged: (date) {
                    markedDates(date);
                  },
                  markedDatesMap: _markedDateMap,
                  iconColor: Theme.of(context).primaryColor,
                  todayButtonColor: Theme.of(context).primaryColor,
                  headerTextStyle:
                      TextStyle(color: Theme.of(context).primaryColor),
                  selectedDateTime: selectedDate,
                  daysHaveCircularBorder: false,
                ),
              ),
              CustomDivider(
                title: "Your Classes",
              ),
              dateSpecificClasses.length == 0
                  ? Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Center(
                          child:
                              Text("There is no any Class on selected date")))
                  : ListView.builder(
                      itemCount: dateSpecificClasses.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        return Container(
                          margin: EdgeInsets.only(top: 20, left: 16, right: 16),
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          color: FlutterFlowTheme.secondaryColor,
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
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        dateSpecificClasses[index].courseName,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
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
                                    dateSpecificClasses[index].roomNo,
                                    style: TextStyle(color: Colors.white),
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
                                        dateSpecificClasses[index]
                                            .startTime
                                            .toDate()),
                                    style: TextStyle(color: Colors.white),
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
                                        dateSpecificClasses[index]
                                            .endTime
                                            .toDate()),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
              SizedBox(
                height: 20,
              ),
              CustomDivider(
                title: "Your Tasks",
              ),
              dateSpecificToDos.length == 0
                  ? Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Center(
                          child: Text("There is no any TODO on selected date")))
                  : ListView.builder(
                      itemCount: dateSpecificToDos.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        return Container(
                          margin: EdgeInsets.only(top: 20, left: 16, right: 16),
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          color: FlutterFlowTheme.secondaryColor,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Todo Name: ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    dateSpecificToDos[index].toDoName,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Description: ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        dateSpecificToDos[index]
                                            .toDoDescription,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  markedDates(DateTime date) {
    List<ClassTimeTableModel> allClasses = [];
    myController.allCourses.forEach((course) {
      course.allClasses.forEach((element) {
        allClasses.add(element);
      });
    });
    _markedDateMap = new EventList<Event>();
    final DateTime lastDay = Utils.lastDayOfMonth(date);
    for (int i = 1; i < lastDay.day + 1; i++) {
      DateTime dateToBeMarked = DateTime(date.year, date.month, i);
      String day = dayConvert(dateToBeMarked);
      print(day);
      List<ClassTimeTableModel> daySpecificClasses =
          allClasses.where((element) => element.day == day).toList();

      daySpecificClasses.forEach((element) {
        _markedDateMap.add(
          dateToBeMarked,
          new Event(
            date: dateToBeMarked,
            dot: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              height: 6,
              width: 6,
            ),
          ),
        );
      });
    }
    markedToDos();
    setState(() {});
  }

  markedToDos() {
    pendingToDos.forEach((element) {
      print("todoDate===> ${element.toDoDate.toDate()}");
      _markedDateMap.add(
        DateTime(element.toDoDate.toDate().year,
            element.toDoDate.toDate().month, element.toDoDate.toDate().day),
        new Event(
          date: DateTime(element.toDoDate.toDate().year,
              element.toDoDate.toDate().month, element.toDoDate.toDate().day),
          dot: Container(
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            height: 6,
            width: 6,
          ),
        ),
      );
    });
  }

  String dayConvert(DateTime dateToBeMarked) {
    if (dateToBeMarked.weekday == 1) {
      return "Monday";
    } else if (dateToBeMarked.weekday == 2) {
      return "Tuesday";
    } else if (dateToBeMarked.weekday == 3) {
      return "Wednesday";
    } else if (dateToBeMarked.weekday == 4) {
      return "Thursday";
    } else if (dateToBeMarked.weekday == 5) {
      return "Friday";
    } else if (dateToBeMarked.weekday == 6) {
      return "Saturday";
    } else if (dateToBeMarked.weekday == 7) {
      return "Sunday";
    }
    return "nomatch";
  }

  getAppointmentsOnSelectedDate() {
    dateSpecificClasses = [];
    String selectedDay = DateFormat("EEEE").format(selectedDate);
    myController.allCourses.forEach((element) {
      element.allClasses.forEach((element) {
        if (element.day == selectedDay) {
          dateSpecificClasses.add(element);
        }
      });
    });

    dateSpecificToDos = [];
    dateSpecificToDos.addAll(pendingToDos
        .where((element) => DateTime(element.toDoDate.toDate().year,
                element.toDoDate.toDate().month, element.toDoDate.toDate().day)
            .isAtSameMomentAs(DateTime(
                selectedDate.year, selectedDate.month, selectedDate.day)))
        .toList());

    setState(() {});
  }
}
