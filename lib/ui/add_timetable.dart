import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sortie/backend/backend.dart';
import 'package:sortie/flutter_flow/flutter_flow_theme.dart';
import 'package:sortie/models/class_timetable_model.dart';
import 'package:sortie/widgets/expandable_box.dart';
import 'package:sortie/widgets/filter_option_widget.dart';
import 'package:sortie/widgets/inputfield_widget.dart';

class AddTimeTable extends StatefulWidget {
  @override
  _AddTimeTableState createState() => _AddTimeTableState();
}

class _AddTimeTableState extends State<AddTimeTable> {
  bool expandDays = false;
  List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  String selectedDay = "Monday";
  TextEditingController dayCon = TextEditingController();
  TextEditingController roomNoCon = TextEditingController();
  TextEditingController startTimeCon = TextEditingController();
  TextEditingController endTimeCon = TextEditingController();

  DateTime selectedStartTime = DateTime(1, 1, 8, 0);
  DateTime selectedEndTime = DateTime(1, 1, 8, 0);

  ClassTimeTableModel timeTableModel;

  @override
  void initState() {
    dayCon.text = selectedDay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Timetable"),
        backgroundColor: FlutterFlowTheme.primaryColor,
        centerTitle: true,
      ),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      expandDays = !expandDays;
                    });
                  },
                  child: InputFieldWidget(
                    enable: false,
                    showDropDown: true,
                    controller: dayCon,
                  ),
                ),
                if (expandDays == true)
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
                      expand: expandDays,
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
                              itemCount: days.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (_, index) {
                                return InkWell(
                                  onTap: () {
                                    expandDays = false;
                                    selectedDay = days[index];
                                    dayCon.text = selectedDay;
                                    setState(() {});
                                  },
                                  child: FilterOptionWidget(
                                    title: days[index],
                                    selectedValue: selectedDay,
                                  ),
                                );
                              })),
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                InputFieldWidget(
                  controller: roomNoCon,
                  hint: "Enter room no",
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      showPicker(
                        blurredBackground: true,
                        accentColor: Color(0xff9BCA27),
                        dialogInsetPadding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.05),
                        iosStylePicker: false,
                        context: context,
                        value: TimeOfDay.fromDateTime(selectedStartTime),
                        onChange: (value) {},
                        minuteInterval: MinuteInterval.ONE,
                        disableHour: false,
                        disableMinute: false,
                        minMinute: 0,
                        maxMinute: 59,
                        is24HrFormat: false,
                        onChangeDateTime: (DateTime dateTime) {
                          setState(() {
                            selectedStartTime = dateTime;
                            startTimeCon.text =
                                DateFormat("hh:mm a").format(selectedStartTime);
                          });
                        },
                      ),
                    );
                  },
                  child: InputFieldWidget(
                    controller: startTimeCon,
                    enable: false,
                    hint: "Pick Start time",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      showPicker(
                        blurredBackground: true,
                        accentColor: Color(0xff9BCA27),
                        dialogInsetPadding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.05),
                        iosStylePicker: false,
                        context: context,
                        value: TimeOfDay.fromDateTime(selectedEndTime),
                        onChange: (value) {},
                        minuteInterval: MinuteInterval.ONE,
                        disableHour: false,
                        disableMinute: false,
                        minMinute: 0,
                        maxMinute: 59,
                        is24HrFormat: false,
                        onChangeDateTime: (DateTime dateTime) {
                          setState(() {
                            selectedEndTime = dateTime;
                            endTimeCon.text =
                                DateFormat("hh:mm a").format(selectedEndTime);
                          });
                        },
                      ),
                    );
                  },
                  child: InputFieldWidget(
                    controller: endTimeCon,
                    enable: false,
                    hint: "Pick End time",
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                InkWell(
                  onTap: saveClass,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    color: FlutterFlowTheme.primaryColor,
                    child: Center(child: Text("Save")),
                  ),
                )
              ],
            ),
          )),
    );
  }

  saveClass() {
    if (roomNoCon.text.isEmpty ||
        startTimeCon.text.isEmpty ||
        endTimeCon.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please fill all the fields.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return;
    }
    timeTableModel = ClassTimeTableModel(
        day: selectedDay,
        endTime: Timestamp.fromDate(selectedEndTime),
        startTime: Timestamp.fromDate(selectedStartTime),
        roomNo: roomNoCon.text,
        uid: DateTime.now().millisecondsSinceEpoch.toString());
    Navigator.pop(context, timeTableModel);
  }
}
