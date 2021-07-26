import 'package:flutter/material.dart';
import 'package:sortie/flutter_flow/flutter_flow_theme.dart';

class CustomDivider extends StatelessWidget {
  final String title;
  CustomDivider({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: FlutterFlowTheme.primaryColor),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 2,
              color: FlutterFlowTheme.primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
