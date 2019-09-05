import 'package:flutter/material.dart';
import 'app_translations.dart';

class HelpMain extends StatefulWidget {
  @override
  _HelpMain createState() => _HelpMain();
}

class _HelpMain extends State<HelpMain> {

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
              AppTranslations.of(context).text("help_main"),
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}