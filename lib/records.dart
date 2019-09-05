import 'dart:io';

class Record {

  // VARIABLES FOR USER IDENTITY, LOCATION, AND PATIENT'S PERSONAL PARTICULARS (part 1 of the record)
  String _index;
  String _accesscode;
  String _username;
  String _emailaddress;
  String _accessdate;
  String _location;
  String _name;
  String _description;
  String _contact;
  bool _cssa;
  String _hkid;
  String _gender;
  String _dob;
  int _age;
  bool _smoking;
  bool _alcohol;
  bool _drugs;
  bool _reject;

  // VARIABLES FOR THE HEALTH INFO OF THE PATIENT (part 2 of the record)
  String _heartrate;
  String _bloodpressure;
  String _bloodglucose;
  String _bodyheight;
  String _bodyweight;
  String _bmi;
  String _respirationrate;
  String _additionalinfo1;

  // VARIABLES FOR THE FURTHER DESCRIPTIONS OF THE PATIENT (part 3 of the record)
  String _wound;
  String _mentalissues;
  String _pastmedrecords;
  String _additionalinfo2;

  List<List<int>> _imagebytes;

  Record(
      String index,
      String accesscode,
      String username,
      String emailaddress,
      String accessdate,
      String location,
      String name,
      String description,
      String gender,
      String contact,
      String hkid,
      bool cssa,
      String dob,
      int age,
      bool reject,
      String heartrate,
      String bloodpressure,
      String bloodglucose,
      String bodyheight,
      String bodyweight,
      String bmi,
      String respirationrate,
      bool smoking,
      bool alcohol,
      bool drugs,
      String additionalinfo1,
      String wound,
      String mentalissues,
      String pastmedrecords,
      String additionalinfo2,
      List<List<int>> imagebytes) {
    _index = index;
    _accesscode = accesscode;
    _username = username;
    _emailaddress = emailaddress;
    _accessdate = accessdate;
    _location = location;
    _name = name;
    _description = description;
    _gender = gender;
    _contact = contact;
    _hkid = hkid;
    _cssa = cssa;
    _dob = dob;
    _age = age;
    _reject = reject;

    _heartrate = heartrate;
    _bloodpressure = bloodpressure;
    _bloodglucose = bloodglucose;
    _bodyweight = bodyweight;
    _bodyheight = bodyheight;
    _bmi = bmi;
    _respirationrate = respirationrate;
    _smoking = smoking;
    _alcohol = alcohol;
    _drugs = drugs;
    _additionalinfo1 = additionalinfo1;

    _wound = wound;
    _mentalissues = mentalissues;
    _pastmedrecords = pastmedrecords;
    _additionalinfo2 = additionalinfo2;

    _imagebytes = imagebytes;
  }

  // GETTERS part 1
  String get_index() {
    return _index;
  }
  String get_accesscode() {
    return _accesscode;
  }
  String get_username() {
    return _username;
  }
  String get_emailaddress() {
    return _emailaddress;
  }
  String get_accessdate() {
    return _accessdate;
  }
  String get_location() {
    return _location;
  }
  String get_name() {
    return _name;
  }
  String get_description() {
    return _description;
  }
  String get_contact() {
    return _contact;
  }
  bool get_cssa() {
    return _cssa;
  }
  String get_hkid() {
    return _hkid;
  }
  String get_gender() {
    return _gender;
  }
  String get_dob() {
    return _dob;
  }
  int get_age() {
    return _age;
  }
  bool get_smoking() {
    return _smoking;
  }
  bool get_alcohol() {
    return _alcohol;
  }
  bool get_drugs() {
    return _drugs;
  }
  bool get_reject() {
    return _reject;
  }

  // GETTERS part 2
  String get_heartrate() {
    return _heartrate;
  }
  String get_bloodpressure() {
    return _bloodpressure;
  }
  String get_bloodglucose() {
    return _bloodglucose;
  }
  String get_height() {
    return _bodyheight;
  }
  String get_weight() {
    return _bodyweight;
  }
  String get_bmi() {
    return _bmi;
  }
  String get_respirationrate() {
    return _respirationrate;
  }
  String get_additionalinfo1() {
    return _additionalinfo1;
  }

  // GETTERS part 3
  String get_wound() {
    return _wound;
  }
  String get_mentalissues() {
    return _mentalissues;
  }
  String get_pastmedrecords() {
    return _pastmedrecords;
  }
  String get_additionalinfo2() {
    return _additionalinfo2;
  }
  List<List<int>> get_imagebytes() {
    return _imagebytes;
  }

  Map<String, dynamic> toMap() {
    return {
      'record_no': _index,
      'accesscode': _accesscode,
      'username': _username,
      'emailaddress': _emailaddress,
      'accessdate': _accessdate,
      'location': _location,
      'name': _name,
      'description': _description,
      'gender': _gender,
      'contact': _contact,
      'hkid': _hkid,
      'cssa': _cssa,
      'dob': _dob,
      'age': _age,
      'reject': _reject,
      'heartrate': _heartrate,
      'bloodpressure': _bloodpressure,
      'bloodglucose': _bloodglucose,
      'bodyheight': _bodyheight,
      'bodyweight': _bodyweight,
      'bmi': _bmi,
      'respirationrate': _respirationrate,
      'smoking': _smoking,
      'alcohol': _alcohol,
      'drugs': _drugs,
      'additionalinfo1': _additionalinfo1,
      'wound': _wound,
      'mentalissues': _mentalissues,
      'pastmedrecords': _pastmedrecords,
      'additionalinfo2': _additionalinfo2,
      'image0': _imagebytes[0],
      'image1': _imagebytes[1],
      'image2':_imagebytes[2],
      'image3':_imagebytes[3],
      'image4':_imagebytes[4],
    };
  }
 
}
