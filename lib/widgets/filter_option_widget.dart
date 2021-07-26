import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterOptionWidget extends StatelessWidget {
  final String title;
  final String selectedValue;

  FilterOptionWidget({this.title, this.selectedValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 12, top: 8, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: GoogleFonts.openSans().fontFamily,
              fontSize: 12,
              color: title == selectedValue ? Color(0xff8fbe3e) : Colors.black,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        title != "Sunday"
            ? Container(
                height: 1,
                color: Colors.black,
              )
            : SizedBox(
                height: 10,
                width: MediaQuery.of(context).size.width,
              )
      ],
    );
  }
}
