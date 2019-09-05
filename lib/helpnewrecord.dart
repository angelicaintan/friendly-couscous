import 'package:flutter/material.dart';
import 'app_translations.dart';

class HelpNewRecord extends StatefulWidget {
  @override
  _HelpNewRecord createState() => _HelpNewRecord();
}

class _HelpNewRecord extends State<HelpNewRecord> {

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
              AppTranslations.of(context).text("help_newrecord"),
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}