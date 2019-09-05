import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'app_translations.dart';
import 'helppatientinfo.dart';
import 'logout.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'newrecord.dart';
import 'records.dart';
import 'main.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'files.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientInfo extends StatefulWidget {
  @override
  _PatientInfoState createState() => _PatientInfoState();
}

class _PatientInfoState extends State<PatientInfo> {
  void _dismissKeyboard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  final _scrollController = new ScrollController();

  // CREATE NEW RECORD
  String index = DateFormat('yyyy-MM-dd-hh:mm:ss-').format(DateTime.now());

  Record newrecord;

  String accesscode;
  String username;
  String emailaddress;

  String accessdate;

  // VARIABLES FOR THE BASIC INFO OF THE PATIENT (part 1 of the record)
  String location;
  String name;
  String description;
  String gender;
  String contact;
  String hkid;
  bool cssa;
  String dob = ' ';
  String agestring;
  int age;
  double agefull;
  int genderValue = -1;
  int cssaValue = -1;
  bool reject = false;

  final locationController = TextEditingController();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final contactController = TextEditingController();
  final hkidController = TextEditingController();
  final ageController = TextEditingController();
  final birthdayController = TextEditingController();

  // VARIABLES AND TEXT CONTROLLERS FOR THE HEALTH INFO OF THE PATIENT (part 2 of the record)
  String heartrate;
  String bloodpressure;
  String bloodglucose;
  String bodyweight;
  String bodyheight;
  String bmi;
  String respirationrate;
  bool smoking = false;
  bool alcohol = false;
  bool drugs = false;
  String additionalinfo1;

  final heartrateController = TextEditingController();
  final bloodpressureController = TextEditingController();
  final bloodglucoseController = TextEditingController();
  final bodyheightController = TextEditingController();
  final bodyweightController = TextEditingController();
  final bmiController = TextEditingController();
  final respirationrateController = TextEditingController();
  final additionalinfo1Controller = TextEditingController();

  // VARIABLES AND TEXT CONTROLLERS FOR THE FURTHER HEALTH DESCRIPTION OF THE PATIENT (part 3 of the record)
  String wound;
  String mentalissues;
  String pastmedrecords;
  String additionalinfo2;

  final woundController = TextEditingController();
  final mentalissuesController = TextEditingController();
  final prevmedrecordsController = TextEditingController();
  final additionalinfo2Controller = TextEditingController();

  List<File> images = new List(5);
  int numfiles = 0;

  _getLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      accesscode = prefs.getString('accesscode');
      username = prefs.getString('username');
      emailaddress = prefs.getString('email');
      accessdate = prefs.getString('accessdate');
    });
  }

  // FUNCTION THAT CHANGES THE VALUE OF THE GENDER BOOL
  void _genderChange(int value) {
    setState(() {
      genderValue = value;

      switch (genderValue) {
        case 0:
          gender = 'female';
          break;
        case 1:
          gender = 'male';
          break;
      }
    });
  }

  // FUNCTION THAT CHANGES THE VALUE OF THE CSSA BOOL
  void _cssaChange(int value) {
    setState(() {
      cssaValue = value;

      switch (cssaValue) {
        case 0:
          cssa = true;
          break;
        case 1:
          cssa = false;
          break;
      }
    });
  }

  // FUNCTION THAT DISPLAYS THE DATE PICKER (for selecting the patient's date of birth) and calculates age
  DateTime selectedDate =
      DateTime.now(); // sets the default selected date as today
  DateTime dateNow = DateTime
      .now(); // stores today's date in a variable to be used in the funct

  void _showDatePicker() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 160,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (value) {
                  selectedDate = value;
                },
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                  child: Text(AppTranslations.of(context).text("ok")),
                  onPressed: () {
                    setState(() {
                      dob = DateFormat('yyyy-MM-dd').format(selectedDate);
                      agefull = ((dateNow.year + (dateNow.month / 12)) -
                              (selectedDate.year + (selectedDate.month / 12)))
                          .toDouble();
                      age = agefull.toInt();
                      ageController.text = '$age';
                    });
                    Navigator.pop(context);
                  }),
              new FlatButton(
                child: Text(AppTranslations.of(context).text("cancel")),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  // FUNCTION THAT OPENS THE PHONE CAMERA (to allow users to take pictures and attach to their records)
  Future _takePicture() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera) ?? null;

    if (image != null) {
      setState(() {
        switch (numfiles) {
          case 0:
            images[0] = image;
            ++numfiles;
            break;
          case 1:
            images[1] = image;
            ++numfiles;
            break;
          case 2:
            images[2] = image;
            ++numfiles;
            break;
          case 3:
            images[3] = image;
            ++numfiles;
            break;
          case 4:
            images[4] = image;
            ++numfiles;
            break;
          case 5:
            _showErrorDialog();
        }
      });
    }
  }

  // FUNCTION THAT OPENS THE PHONE GALLERY (to allow users to select pictures and attach to their records)
  Future _selectPicture() async {
    var image =
        await ImagePicker.pickImage(source: ImageSource.gallery) ?? null;

    if (image != null) {
      setState(() {
        switch (numfiles) {
          case 0:
            images[0] = image;
            ++numfiles;
            break;
          case 1:
            images[1] = image;
            ++numfiles;
            break;
          case 2:
            images[2] = image;
            ++numfiles;
            break;
          case 3:
            images[3] = image;
            ++numfiles;
            break;
          case 4:
            images[4] = image;
            ++numfiles;
            break;
          case 5:
            _showErrorDialog();
        }
      });
    }
  }

  // FUNCTION THAT DISPLAYS ERROR DIALOG
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(AppTranslations.of(context).text("error_photos")),
          content: new Text(AppTranslations.of(context).text("remove_photo")),
          actions: <Widget>[
            new FlatButton(
                child: Text(AppTranslations.of(context).text("ok")),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }

  // FUNCTION THAT REMOVES THE PHOTOS FROM THE IMAGE FILE LIST
  void _deletePic(int i) {
    setState(() {
      images[i] = null;
      for (; i != numfiles - 1; ++i) images[i] = images[i + 1];
      --numfiles;
    });
  }

/*
  // FUNCTION THAT STORES THE PATIENT'S INFO IN SHARED PREFERENCES (for temporary storage before uploading to firebase)
  _persistPatientInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // PART 1
    prefs.setString('location', location);
    prefs.setString('name', name);
    prefs.setString('description', description);
    prefs.setString('gender', gender);
    prefs.setString('contact', contact);
    prefs.setBool('cssa', cssa);
    prefs.setString('HKID', hkid);
    prefs.setString('birthday', dob);
    prefs.setInt('age', age);
    prefs.setBool('reject', reject);

    // PART 2
    prefs.setString('heart-rate', heartrate);
    prefs.setString('blood-pressure', bloodpressure);
    prefs.setString('blood-glucose', bloodglucose);
    prefs.setString('body-height', bodyheight);
    prefs.setString('body-weight', bodyweight);
    prefs.setString('BMI', bmi);
    prefs.setString('respiration-rate', respirationrate);
    prefs.setBool('smoking', smoking);
    prefs.setBool('alcohol', alcohol);
    prefs.setBool('drugs', drugs);
    prefs.setString('additional-info1', additionalinfo1);

    // PART 3
    prefs.setString('wound', woundController.text);
    prefs.setString('mental-issues', mentalissuesController.text);
    prefs.setString('past-med-records', prevmedrecordsController.text);
    prefs.setString('additional-info2', additionalinfo2Controller.text);
  }
  */

  // FUNCTION THAT STORES PATIENT'S INFO IN SQLITE
  Future<void> insertRecord(Record record) async {
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

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

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
      MyInherited.of(context).newrecord(newrecord);
    }
  }

// FUNCTION THAT DISPLAYS DIALOG TO ASK USER IF THEY'D LIKE TO SUBMIT THE RECORDS
  void _showDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(AppTranslations.of(context).text("finish?")),
          content: new Text(AppTranslations.of(context).text("you_cant_edit")),
          actions: <Widget>[
            new FlatButton(
                child: Text(AppTranslations.of(context).text("finish")),
                onPressed: () async {
                  // convert images to bytes
                  List<List<int>> bytes = new List(images.length);
                  for (int i = 0; images[i] != null; ++i) {
                    bytes[i] = await images[i].readAsBytes();
                  }

                  await _getLogin();
                  Record newrecord = new Record(
                      index,
                      accesscode,
                      username,
                      emailaddress,
                      accessdate,
                      location,
                      name,
                      description,
                      gender,
                      contact,
                      hkid,
                      cssa,
                      dob,
                      age,
                      reject,
                      heartrate,
                      bloodpressure,
                      bloodglucose,
                      bodyheight,
                      bodyweight,
                      bmi,
                      respirationrate,
                      smoking,
                      alcohol,
                      drugs,
                      additionalinfo1,
                      wound,
                      mentalissues,
                      pastmedrecords,
                      additionalinfo2,
                      bytes);

                  insertRecord(newrecord);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserFiles()),
                  );
                }),
            new FlatButton(
              child: Text(AppTranslations.of(context).text("cancel")),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(actions: <Widget>[
          // HELP BUTTON
          IconButton(
            icon: Icon(Icons.help_outline, size: 29),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpPatientInfo()),
              );
            },
          ),
        ]),
        body: ListView(controller: _scrollController, children: <Widget>[
          GestureDetector(
            onTap: () => _dismissKeyboard(),
            child: Column(
              children: <Widget>[
                // **PART 1: BASIC PATIENT INFO**
                // LOCATION TEXTFIELD
                Padding(
                  padding: EdgeInsets.only(left: 24, right: 24, top: 50),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(AppTranslations.of(context).text("location"),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10),
                  child: TextField(
                    controller: locationController,
                    onChanged: (text) {
                      location = text;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),

                // PATIENT'S NAME TEXTFIELD
                Padding(
                  padding: EdgeInsets.only(left: 24, right: 24, top: 24),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                        AppTranslations.of(context)
                            .text("personal_particulars"),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10),
                  child: TextField(
                    controller: nameController,
                    onChanged: (text) {
                      name = text;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: AppTranslations.of(context).text("name"),
                        labelStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),

                // DESCRIPTION OF PATIENT TEXTFIELD
                Padding(
                  padding: EdgeInsets.only(left: 24, right: 24, bottom: 5),
                  child: TextField(
                    controller: descController,
                    onChanged: (text) {
                      description = text;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText:
                            AppTranslations.of(context).text("description"),
                        labelStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),

                // GENDER SELECTION RADIO BUTTONS
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Text(AppTranslations.of(context).text("gender"),
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Radio(
                        groupValue: genderValue,
                        value: 0,
                        onChanged: _genderChange,
                      ),
                    ),
                    Text(AppTranslations.of(context).text("male"),
                        style: TextStyle(fontSize: 16)),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Radio(
                        groupValue: genderValue,
                        value: 1,
                        onChanged: _genderChange,
                      ),
                    ),
                  ],
                ),

                // PATIENT'S CONTACT INFO TEXTFIELD
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 24),
                  child: TextField(
                    controller: contactController,
                    onChanged: (text) {
                      contact = text;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: AppTranslations.of(context).text("contact"),
                        labelStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),

                // PATIENT'S HKID NUMBER TEXTFIELD
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 24),
                  child: TextField(
                    controller: hkidController,
                    onChanged: (text) {
                      hkid = text;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: AppTranslations.of(context).text("hkid"),
                        labelStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),

                // CSSA RADIO BUTTONS
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Text(AppTranslations.of(context).text("cssa"),
                          style: TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Radio(
                        groupValue: cssaValue,
                        value: 0,
                        onChanged: _cssaChange,
                      ),
                    ),
                    Text(AppTranslations.of(context).text("no"),
                        style: TextStyle(fontSize: 16)),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Radio(
                        groupValue: cssaValue,
                        value: 1,
                        onChanged: _cssaChange,
                      ),
                    ),
                  ],
                ),

                // TEXT AND BUTTON TO TRIGGER THE DATEPICKER
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Text(AppTranslations.of(context).text("date_of_birth"),
                      style: TextStyle(fontSize: 16)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: RaisedButton(
                    onPressed: () => _showDatePicker(),
                    child:
                        Text(AppTranslations.of(context).text("select_date")),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(dob, style: TextStyle(fontSize: 16)),
                ),

                // AGE TEXTFIELD -- CONTROLLER AUTOMATICALLY CHANGES VALUE WHEN DATE OF BIRTH IS SELECTED
                Padding(
                  padding: EdgeInsets.only(top: 24, left: 24, right: 24),
                  child: TextField(
                    controller: ageController,
                    onChanged: (text) {
                      setState(() {
                        agestring = text;
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: AppTranslations.of(context).text("age"),
                        labelStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),

                // BUTTON TO PRESS IF PATIENT REJECTS SERVICE -- navigates to newrecord page while still uploading basic patient data to firebase
                Padding(
                  padding: EdgeInsets.all(24),
                  child: RaisedButton(
                    child: Text(AppTranslations.of(context).text("reject")),
                    onPressed: () {
                      _showDialog();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewRecord()),
                      );
                      setState(() {
                        reject = true;
                      });
                    },
                  ),
                ),

                // **PART 2: GENERAL MEDICAL DATA**
                Padding(
                  padding: EdgeInsets.only(left: 24, right: 24, top: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                        AppTranslations.of(context)
                            .text("general_medical_data"),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 5),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          children: <Widget>[
                            // HEART RATE TEXTFIELD
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextField(
                                controller: heartrateController,
                                onChanged: (text) {
                                  heartrate = text;
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: AppTranslations.of(context)
                                        .text("heart_rate"),
                                    labelStyle: TextStyle(fontSize: 16),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),
                            ),

                            // BLOOD PRESSURE TEXTFIELD
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextField(
                                controller: bloodpressureController,
                                onChanged: (text) {
                                  bloodpressure = text;
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: AppTranslations.of(context)
                                        .text("blood_pressure"),
                                    labelStyle: TextStyle(fontSize: 16),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),
                            ),

                            // BLOOD GLUCOSE TEXTFIELD
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextField(
                                controller: bloodglucoseController,
                                onChanged: (text) {
                                  bloodglucose = text;
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: AppTranslations.of(context)
                                        .text("blood_glucose"),
                                    labelStyle: TextStyle(fontSize: 16),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),
                            ),

                            // BODY WEIGHT TEXTFIELD
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextField(
                                controller: bodyweightController,
                                onChanged: (text) {
                                  bodyweight = text;
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: AppTranslations.of(context)
                                        .text("body_weight"),
                                    labelStyle: TextStyle(fontSize: 16),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),
                            ),

                            // BODY HEIGHT TEXTFIELD
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextField(
                                controller: bodyheightController,
                                onChanged: (text) {
                                  bodyheight = text;
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: AppTranslations.of(context)
                                        .text("body_height"),
                                    labelStyle: TextStyle(fontSize: 16),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),
                            ),

                            // BMI TEXTFIELD
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextField(
                                controller: bmiController,
                                onChanged: (text) {
                                  bmi = text;
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText:
                                        AppTranslations.of(context).text("bmi"),
                                    labelStyle: TextStyle(fontSize: 16),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),
                            ),

                            // RESPIRATION RATE
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextField(
                                controller: respirationrateController,
                                onChanged: (text) {
                                  respirationrate = text;
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: AppTranslations.of(context)
                                        .text("respiration_rate"),
                                    labelStyle: TextStyle(fontSize: 16),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  top: 35, left: 10, bottom: 50),
                              child:
                                  Text('bpm', style: TextStyle(fontSize: 16))),
                          Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 50),
                              child:
                                  Text('mmHg', style: TextStyle(fontSize: 16))),
                          Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 50),
                              child: Text('mmol/L',
                                  style: TextStyle(fontSize: 16))),
                          Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 50),
                              child:
                                  Text('cm', style: TextStyle(fontSize: 16))),
                          Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 50),
                              child:
                                  Text('kg', style: TextStyle(fontSize: 16))),
                          Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 50),
                              child: Text('kg/m\u00B2',
                                  style: TextStyle(fontSize: 16))),
                          Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 50),
                              child: Text('breaths/min',
                                  style: TextStyle(fontSize: 16))),
                        ],
                      ),
                    ],
                  ),
                ),

                // ROW OF CHECKBOXES
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(AppTranslations.of(context).text("smoking"),
                              style: TextStyle(fontSize: 16)),

                          // SMOKING CHECKBOX
                          new Checkbox(
                            value: smoking,
                            onChanged: (bool newValue) {
                              setState(() {
                                smoking = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(AppTranslations.of(context).text("alcohol"),
                              style: TextStyle(fontSize: 16)),

                          // ALCOHOL CHECKBOX
                          new Checkbox(
                            value: alcohol,
                            onChanged: (bool newValue) {
                              setState(() {
                                alcohol = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(AppTranslations.of(context).text("drug_abuse"),
                              style: TextStyle(fontSize: 16)),

                          // DRUG ABUSE CHECKBOX
                          new Checkbox(
                            value: drugs,
                            onChanged: (bool newValue) {
                              setState(() {
                                drugs = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ADDITIONAL INFO TEXTFIELD
                Padding(
                  padding: EdgeInsets.only(top: 5, left: 24, right: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        AppTranslations.of(context)
                            .text("additional_information1"),
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                  child: TextField(
                    controller: additionalinfo1Controller,
                    onChanged: (text) {
                      additionalinfo1 = text;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: AppTranslations.of(context)
                            .text("e.g._lost_weight"),
                        labelStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),

                Padding(padding: EdgeInsets.symmetric(vertical: 10)),

                Padding(
                  padding: EdgeInsets.only(left: 24, right: 24, top: 50),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                        AppTranslations.of(context)
                            .text("additional_description"),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),

                // ** PART 3: FURTHER HEALTH DESCRIPTIONS**
                // WOUND DESCRIPTION TEXTFIELD
                Padding(
                  padding:
                      EdgeInsets.only(top: 24, bottom: 5, left: 28, right: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(AppTranslations.of(context).text("wound"),
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20, left: 24, right: 24),
                  child: TextField(
                      controller: woundController,
                      onChanged: (text) {
                        setState(() {
                          wound = text;
                        });
                      },
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          labelText: '',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                      maxLines: null),
                ),

                // MENTAL ISSUES DESCRIPTION TEXTIELD
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 28),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        AppTranslations.of(context).text("mental_issues"),
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 0, bottom: 20, left: 24, right: 24),
                  child: TextField(
                      controller: mentalissuesController,
                      onChanged: (text) {
                        setState(() {
                          mentalissues = text;
                        });
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: '',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                      maxLines: null),
                ),

                // PREVIOUS MEDICAL RECORDS TEXTFIELD
                Padding(
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 28, right: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        AppTranslations.of(context)
                            .text("previous_medical_records"),
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 0, bottom: 20, left: 24, right: 24),
                  child: TextField(
                      controller: prevmedrecordsController,
                      onChanged: (text) {
                        setState(() {
                          pastmedrecords = text;
                        });
                      },
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          labelText: '',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                      maxLines: null),
                ),

                // ADDITIONAL INFO TEXTFIELD
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 28),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        AppTranslations.of(context)
                            .text("additional_information2"),
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 0, bottom: 20, left: 24, right: 24),
                  child: TextField(
                      controller: additionalinfo2Controller,
                      onChanged: (text) {
                        additionalinfo2 = text;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: '',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                      maxLines: null),
                ),

                // ROW OF BUTTONS AND TEXT DESCRIPTIONS FOR PHOTO TAKING AND UPLOADING
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 24, bottom: 5),
                      child: Text(
                          AppTranslations.of(context)
                              .text("additional_files_photos"),
                          style: TextStyle(fontSize: 16)),
                    ),

                    // CAMERA BUTTON
                    IconButton(
                      alignment: Alignment.centerRight,
                      icon: Icon(Icons.photo_camera),
                      color: Colors.black,
                      onPressed: () {
                        _takePicture();
                      },
                    ),

                    // ATTACHMENT BUTTON
                    IconButton(
                      alignment: Alignment.centerRight,
                      icon: Icon(Icons.attach_file),
                      color: Colors.black,
                      onPressed: () {
                        _selectPicture();
                      },
                    ),
                  ],
                ),

                // DESCRIPTION FOR HOW MUCH USER CAN UPLOAD
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 28, bottom: 20),
                      child: SizedBox(
                        width: 80,
                        child: Text(
                            AppTranslations.of(context).text("you_can_upload"),
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 24),
                        child: Text(
                            '$numfiles/5'), // COUNTS NUMBER OF PHOTOS UPLOADED BY USER
                      ),
                    ),
                  ],
                ),

                // DYNAMIC LIST OF UPLOADED PHOTOS
                Padding(
                  padding:
                      EdgeInsets.only(left: 24, top: 24, bottom: 24, right: 96),
                  child: new ListView.builder(
                      shrinkWrap: true,
                      itemCount: numfiles,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return new Row(children: <Widget>[
                          Image.file(images[index],
                              height: 100.0, width: 100.0),

                          // DELETE BUTTON, CALLS _deletePic FUNCTION
                          FlatButton(
                              child: Text(
                                  AppTranslations.of(context).text("delete")),
                              onPressed: () {
                                _deletePic(index);
                              }),
                        ]);
                      }),
                ),

                // FINISH RECORD BUTTON -- CALLS _showDialog
                Align(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    child:
                        Text(AppTranslations.of(context).text("finish_record")),
                    onPressed: () {
                      if (agestring != null) {age = int.parse(agestring);}
                      _showDialog();
                    },
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
