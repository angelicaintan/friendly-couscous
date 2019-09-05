import 'package:flutter/material.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'app_translations.dart';
import 'records.dart';
import 'helpfiles.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'listfiles.dart';
import 'dart:io';
import 'dart:async';
import 'newrecord.dart';
import 'patientinfo.dart';
import 'logout.dart';

class UserFiles extends StatefulWidget {
  @override
  _UserFilesState createState() => _UserFilesState();
}

class _UserFilesState extends State<UserFiles> {
  List<Record> test = [];
  int numfiles = 0;

  Future<void> _retrieveRecords() async {
    final Future<Database> database = openDatabase(
      // Set the path to the database.
      path.join(await getDatabasesPath(), 'records_database.db'),

      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
            "CREATE TABLE records (record_no STRING PRIMARY KEY, accesscode TEXT, username TEXT, emailaddress TEXT, accessdate TEXT, location TEXT, name TEXT, description TEXT, gender TEXT, contact TEXT, hkid TEXT, cssa INTEGER, dob TEXT, age INTEGER, reject INTEGER, heartrate TEXT, bloodpressure TEXT, bloodglucose TEXT, bodyheight TEXT, bodyweight TEXT, bmi TEXT, respirationrate TEXT, smoking INTEGER, alcohol INTEGER, drugs INTEGER, additionalinfo1 TEXT, wound TEXT, mentalissues TEXT, pastmedrecords TEXT, additionalinfo2 TEXT, image0 BLOB, image1 BLOB, image2 BLOB, image3 BLOB, image4 BLOB)");
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Records.
    final List<Map<String, dynamic>> maps = await db.query('records');

    // Convert to records
    for (int i = 0; i < maps.length; ++i) {
      Record newrecord = new Record(
        maps[i]['record_no'],
        maps[i]['accesscode'],
        maps[i]['username'],
        maps[i]['emailaddress'],
        maps[i]['accessdate'],
        maps[i]['location'],
        maps[i]['name'],
        maps[i]['description'],
        maps[i]['gender'],
        maps[i]['contact'],
        maps[i]['hkid'],
        maps[i]['cssa'],
        maps[i]['dob'],
        maps[i]['age'],
        maps[i]['reject'] == 0 ? false : true,
        maps[i]['heartrate'],
        maps[i]['bloodpressure'],
        maps[i]['bloodglucose'],
        maps[i]['bodyheight'],
        maps[i]['bodyweight'],
        maps[i]['bmi'],
        maps[i]['respirationrate'],
        maps[i]['smoking'] == 0 ? false : true,
        maps[i]['alcohol'] == 0 ? false : true,
        maps[i]['drugs'] == 0 ? false : true,
        maps[i]['additionalinfo1'],
        maps[i]['wound'],
        maps[i]['mentalissues'],
        maps[i]['pastmedrecords'],
        maps[i]['additionalinfo2'],
        maps[i]['bytes'],
      );

      setState(() {
        test.add(newrecord);
        ++numfiles;
      });
      // print(i);
    }
  }

  @override
  void initState() {
    setState(() {
      _retrieveRecords();
    });
    super.initState();
  }

  void _deleteTest(int i) {
    setState(() {
      // print("length = ${test.length}");
      // print("i = $i");
      test.removeAt(i);
      --numfiles;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _deleteRecords(final String record_no) async {
      final Future<Database> database = openDatabase(
        // Set the path to the database.
        path.join(await getDatabasesPath(), 'records_database.db'),
      );

      // Get a reference to the database.
      final db = await database;

      // Remove the record from the Database.
      await db.delete(
        'records',
        // Use a `where` clause to delete a specific record.
        where: "record_no = ?",
        // Pass the records's id as a whereArg to prevent SQL injection.
        whereArgs: [record_no],
      );
    }

    void _showDialog() async {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Error! Unable to upload files"),
              content: new Text(
                  "Please try again when device is connected to the internet."),
              // CircularProgressIndicator(),
              actions: <Widget>[
                new FlatButton(
                  child: Text("ok"),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            );
          });
    }

    Future<bool> _checkConnection() async {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      } on SocketException catch (_) {
        return false;
      }
    }

    Future<Null> _uploadRecords(final List<Map<String, dynamic>> maps) async {
      
      for (int i = 0; i < maps.length; ++i) {

        var record = Firestore.instance.collection('Records').document();

        Map<String, dynamic> recordMap = {
          'accessCode': maps[i]['accesscode'],
          'b. user-name': maps[i]['username'],
          'c. user-contact': maps[i]['emailaddress'],
          'accessDate': maps[i]['accessdate'],
          'd. location': maps[i]['location'],
          'name': maps[i]['name'],
          'f. description': maps[i]['description'],
          'g. gender': maps[i]['gender'],
          'h. contact': maps[i]['contact'],
          'HKID': maps[i]['hkid'],
          'j. CSSA': maps[i]['cssa'],
          'k. birthday': maps[i]['dob'],
          'l. age': maps[i]['age'],
          'm. reject': maps[i]['reject'],
          'n. heart-rate': maps[i]['heartrate'],
          'o. blood-pressure': maps[i]['bloodpressure'],
          'p. blood-glucose': maps[i]['bloodglucose'],
          'q. body-height': maps[i]['bodyheight'],
          'r. body-weight': maps[i]['bodyweight'],
          's. bmi': maps[i]['bmi'],
          't. respiration-rate': maps[i]['respirationrate'],
          'u. smoking': maps[i]['smoking'],
          'v. alcohol': maps[i]['alcohol'],
          'w. drugs': maps[i]['drugs'],
          'x. additional-info1': maps[i]['additionalinfo1'],
          'y. wound': maps[i]['wound'],
          'z. mental-issues': maps[i]['mentalissues'],
          'za. past-med-records': maps[i]['pastmedrecords'],
          'zb. additional-info2': maps[i]['additionalinfo2'],
        };

        record.setData(recordMap);

        // upload photos
        String accesscode = maps[i]['accesscode'];
        String username = maps[i]['username'];
        String patientname = maps[i]['name'];
        String accessdate = maps[i]['accessdate'];

        for (int j = 0; maps[i]['image$j'] != null; ++j) {
          final StorageReference firebaseStorageRef = FirebaseStorage.instance
              .ref()
              .child(
                  '$accessdate-$accesscode-$username-$patientname-image$j.jpeg');

          final StorageUploadTask task =
              firebaseStorageRef.putData(maps[i]['image$j']);
        }
      }
    }

    //  FUNCTION THAT UPLOADS THE RECORDS
    Future<Null> _upload() async {
      if (await _checkConnection()) {
        // proceed only if there is connection
        final Future<Database> database = openDatabase(
          // Set the path to the database.
          path.join(await getDatabasesPath(), 'records_database.db'),
        );

        // Get a reference to the database.
        final Database db = await database;

        // Query the table for all The Records.
        final List<Map<String, dynamic>> maps = await db.query('records');

        print(maps.length);

        if (test.length == 0) {
          return;
        }

        // Upload to firebase
        await _uploadRecords(maps);

        // delete records after uploading them
        for (int i = 0; i < maps.length; ++i) {
          _deleteRecords(maps[i]['record_no']);
        }

        for (int i=maps.length-1; i>=0; --i) {
           _deleteTest(i);
        }
      } else {
        _showDialog();
      }
    }

    return new Scaffold(
        appBar: AppBar(leading: Container(), actions: <Widget>[
          // LOG OUT BUTTON
          FlatButton(
            child: Text(AppTranslations.of(context).text("logout"),
                style: TextStyle(fontSize: 18, color: Colors.white)),
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
                MaterialPageRoute(builder: (context) => HelpFiles()),
              );
            },
          ),
        ]),
        body: new ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 24),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 24, top: 24, bottom: 24, right: 24),
              child: new ListView.builder(
                  shrinkWrap: true,
                  itemCount: test.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return new Row(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(test[index].get_index()),
                      ),

                      // DELETE BUTTON, CALLS _deleteTest FUNCTION
                      FlatButton(
                          child:
                              Text(AppTranslations.of(context).text("delete")),
                          onPressed: () {
                            _deleteRecords(test[index].get_index());
                            _deleteTest(index);
                          }),
                    ]);
                  }),
            ),
            Padding(
                padding: EdgeInsets.all(24),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 25),
                      child: RaisedButton(
                        child: Text(AppTranslations.of(context).text("upload_records")),
                        onPressed: () {
                          setState(() {
                            _upload();
                          });
                        },
                      ),
                    ),
                    RaisedButton(
                      child: Text(AppTranslations.of(context).text("return")),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewRecord()),
                        );
                      },
                    ),
                  ],
                ))
          ],
        ));
  }
}
