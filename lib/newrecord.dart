import 'package:flutter/material.dart';
import 'helpnewrecord.dart';
import 'patientinfo.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'app_translations.dart';
import 'files.dart';
import 'records.dart';
import 'logout.dart';

class NewRecord extends StatefulWidget {
  @override
  _NewRecordState createState() => _NewRecordState();
}

class _NewRecordState extends State<NewRecord> {

  // STRING THAT STORES THE DATE IN WHICH THE 'NEW RECORD' BUTTON IS PRESSED (for firebase data filtering function)
  String accessdate;

  // STORES ACCESSDATE IN SHARED PREFERENCES
   _persistaccessdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accessdate', accessdate);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(leading: new Container(), actions: <Widget>[

          // LOG OUT BUTTON
          FlatButton(
            child: Text(AppTranslations.of(context).text("logout"), style: TextStyle(fontSize: 18, color: Colors.white)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LocalisedApp()),
              );
            },
          ),

          // HELP BUTTON
          IconButton(
            icon: Icon(Icons.help_outline, size: 29),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpNewRecord()),
              );
            },
          ),
        ]),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Padding(
                padding:EdgeInsets.only(top:50),
              ),

              // BUTTON THAT NAVIGATES TO THE 'PATIENT INFO' PAGE (where patient's data is recorded on)
              // button also:
              // -takes today's date and stores it in the accesscode variable
              // -calls the _persistaccessdate() function
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: RaisedButton(
                  padding: EdgeInsets.all(20),
                  child: Text(AppTranslations.of(context).text("new_record"), style: TextStyle(fontSize: 21)),
                  onPressed: () {
                    setState(() {
                      accessdate = DateFormat('yyyy-MM-dd').format(DateTime.now());
                    });
                    _persistaccessdate();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PatientInfo()),
                    );
                  },
                ),
              ),
              /*
              // BUTTON THAT NAVIGATES TO THE 'LOGOUT' PAGE 
              RaisedButton(
                padding: EdgeInsets.all(20),
                child: Text(AppTranslations.of(context).text("finish_outreach"), style: TextStyle(fontSize: 21)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LocalisedApp()),
                  );
                },
              ),
              */
              Padding(
                padding: EdgeInsets.all(30),
                child: RaisedButton(
                  padding: EdgeInsets.all(20),
                  child: Text(AppTranslations.of(context).text("my_files"), style: TextStyle(fontSize: 21)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserFiles()),
                    );
                  },
                ),
              ),

            ],
          ),
        ));
  }
}
