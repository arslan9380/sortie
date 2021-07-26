import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManualSchedWidget extends StatefulWidget {
  ManualSchedWidget({Key key}) : super(key: key);

  @override
  _ManualSchedWidgetState createState() => _ManualSchedWidgetState();
}

class _ManualSchedWidgetState extends State<ManualSchedWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.primaryColor,
        automaticallyImplyLeading: true,
        actions: [],
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: FlutterFlowTheme.darkBG,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Class description here',
                  style: FlutterFlowTheme.bodyText1.override(
                    fontFamily: 'Lexend Deca',
                  ),
                )
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment(0.05, 0.55),
                child: IconButton(
                  onPressed: () {
                    print('IconButton pressed ...');
                  },
                  icon: Icon(
                    Icons.add_box_outlined,
                    color: FlutterFlowTheme.primaryColor,
                    size: 40,
                  ),
                  iconSize: 40,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
