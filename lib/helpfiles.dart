import 'package:flutter/material.dart';
import 'app_translations.dart';

class HelpFiles extends StatefulWidget {
  @override
  _HelpFiles createState() => _HelpFiles();
}

class _HelpFiles extends State<HelpFiles> {

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
              AppTranslations.of(context).text("help_files"),
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}