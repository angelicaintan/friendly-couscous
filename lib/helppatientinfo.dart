import 'package:flutter/material.dart';
import 'app_translations.dart';

class HelpPatientInfo extends StatefulWidget {
  @override
  _HelpPatientInfo createState() => _HelpPatientInfo();
}

class _HelpPatientInfo extends State<HelpPatientInfo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Text(
              AppTranslations.of(context).text("help_patientinfo"), style: TextStyle(fontSize: 21),
            ),
          ),
        ],
      ),
    );
  }
}