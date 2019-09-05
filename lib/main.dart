import 'package:flutter/material.dart';
import 'package:drleveldown/app_translations_delegate.dart';
import 'package:drleveldown/application.dart';
import 'package:drleveldown/language_selector_icon_button.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'helpmain.dart';
import 'app_translations.dart';
import 'newrecord.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'records.dart';

import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

/*
class InheritedRecords extends InheritedWidget {
  final List<Record> records;

  InheritedRecords({this.records, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static InheritedRecords of(BuildContext context) =>
    context.inheritFromWidgetOfExactType(InheritedRecords);
}
*/

class MyInherited extends StatefulWidget {
  Widget child;

  MyInherited({this.child});

  @override
  MyInheritedState createState() => new MyInheritedState();

  static MyInheritedState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_MyInherited) as _MyInherited).data;
  }
}

class MyInheritedState extends State<MyInherited> {
  final List<Record> records = [];

  // only expose a getter to prevent bad usage
  List<Record> get myField => records;

  void newrecord(Record newrecord) {
    setState(() {
      records.add(newrecord);
    });
  }

  void deleterecord(Record deletedrecord) {
    setState(() {
      records.removeWhere((item) => (item.get_index == deletedrecord.get_index()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _MyInherited(
      data: this,
      child: widget.child,
    );
  }
}

/// Only has MyInheritedState as field.
class _MyInherited extends InheritedWidget {
  final MyInheritedState data;

  _MyInherited({Key key, this.data, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_MyInherited old) {
    return true;
  }
}

/*
void main() {
  runApp(LocalisedApp());
}
*/

void main() {
  runApp(new MyInherited(child: new LocalisedApp()));
}

class LocalisedApp extends StatefulWidget {
  @override
  LocalisedAppState createState() {
    return new LocalisedAppState();
  }
}

class LocalisedAppState extends State<LocalisedApp> {
  AppTranslationsDelegate _newLocaleDelegate;

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      localizationsDelegates: [
        _newLocaleDelegate,
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("en", ""),
        const Locale("hk", ""),
      ],
    );
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _dismissKeyboard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  String username = 'n/a';
  String email = 'n/a';
  String accesscode = 'n/a';

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final accesscodeController = TextEditingController();

  _persistLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accesscode', accesscode);
    prefs.setString('username', username);
    prefs.setString('email', email);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            actions: <Widget>[
              // HELP BUTTON
              IconButton(
                icon: Icon(Icons.help_outline, size: 29),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpMain()),
                  );
                },
              ),

              // BUTTON THAT GOES TO THE LANGUAGE SELECTOR PAGE
              LanguageSelectorIconButton(),
            ]),
        body: ListView(children: <Widget>[
          GestureDetector(
            onTap: () => _dismissKeyboard(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/logo.png'),

                // TEXTFIELD FOR ACCESS CODE
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: TextField(
                    controller: accesscodeController,
                    onChanged: (text) {
                      accesscode = text;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText:
                            AppTranslations.of(context).text('access_code'),
                        labelStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),

                // TEXTFIELD FOR VOLUNTEER'S NAME
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: TextField(
                    controller: usernameController,
                    onChanged: (text) {
                      username = text;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText:
                            AppTranslations.of(context).text('user_name'),
                        labelStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),

                // TEXTFIELD FOR VOLUNTEER'S EMAIL ADDRESS
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: TextField(
                    controller: emailController,
                    onChanged: (text) {
                      email = text;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText:
                            AppTranslations.of(context).text('email_address'),
                        labelStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),

                // BUTTON TO GO TO THE 'NEW RECORD' PAGE (also calls the persistlogin function to store the login data)
                RaisedButton(
                  child: Text(
                    AppTranslations.of(context).text('go'),
                  ),
                  onPressed: () {
                    _persistLogin();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewRecord()),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),
              ],
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ]));
  }
}
