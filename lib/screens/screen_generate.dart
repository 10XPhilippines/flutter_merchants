import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_merchants/screens/screen_scanned.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_merchants/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_select/smart_select.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_merchants/models/province.dart';
import 'package:flutter_merchants/models/city.dart';
import 'package:flutter_merchants/models/barangay.dart';
import 'package:twitter_qr_scanner/twitter_qr_scanner.dart';
import 'package:twitter_qr_scanner/QrScannerOverlayShape.dart';

var merchantQrData;
bool merchantQrDataHasValue = false;

class GenerateScreen extends StatefulWidget {
  @override
  _GenerateScreenState createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  String bytes;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController p = TextEditingController();
  final TextEditingController b = TextEditingController();
  final TextEditingController m = TextEditingController();
  final TextEditingController s = TextEditingController();
  final TextEditingController companionProvince = TextEditingController();
  final TextEditingController companionCity = TextEditingController();
  final TextEditingController companionStreet = TextEditingController();
  final TextEditingController companionBarangay = TextEditingController();
  Map profile = {};
  bool _isLoading = false;
  String data;
  String userId;
  String dateEntry;
  String dateExit;
  String soreThroat;
  String headAche;
  String fever;
  String cough;
  String exposure;
  String travelHistory;
  String bodyPain;
  int indicator = 0;
  bool isDone = false;
  int companionId;
  String companionFirstName;
  String companionLastName;
  String companionPhoneNumber;
  String companionTemperature;
  String e1, e2, e3, e4, e5, e6, e7, e8;
  String pn, temperature;
  bool hasAddress;
  // var rawJson = ['Q1', 'Q2', 'Q3', 'Q4', 'Q5', 'Q6', 'Q7'];
  var rawJson = ['No', 'No', 'No', 'No', 'No', 'No', 'No'];

  List<SmartSelectOption<String>> options = [
    SmartSelectOption<String>(value: 'Yes', title: 'Yes'),
    SmartSelectOption<String>(value: 'No', title: 'No'),
  ];

  DateTime now = DateTime.now();

  getProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    data = preferences.getString("user");
    setState(() {
      profile = json.decode(data);
      userId = profile["id"].toString();
      dateEntry = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
      rawJson.insert(0, userId);
      rawJson.insert(1, dateEntry);
      var number = new Random();
      companionId = number.nextInt(900000) + 100000;
      rawJson.insert(9, companionId.toString());
    });

    getUserData();

    print(rawJson);
    print(companionId);
    //_generateBarCode(rawJson.toString());
  }

  Future getUserData() async {
    var res = await Network().getData('/user/' + userId.toString());
    var body = json.decode(res.body);

    if (body["user"]["barangay"] == null ||
        body["user"]["city"] == null ||
        body["user"]["province"] == null ||
        body["user"]["street"] == null ||
        body["user"]["phone"] == null) {
      setState(() {
        hasAddress = false;
        b.text = body["user"]["barangay"];
        p.text = body["user"]["province"];
        m.text = body["user"]["city"];
        s.text = body["user"]["street"];
        pn = body["user"]["phone"];
      });
    } else {
      setState(() {
        hasAddress = true;
      });
    }

    if (hasAddress == false) {
      showUpdateAddress();
    }
  }

  showLoading() async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 150),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: const EdgeInsets.all(20.0),
          content: new Container(
            height: 20.0,
            alignment: Alignment.center,
            child: SizedBox(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 2.0,
              ),
              height: 15.0,
              width: 15.0,
            ),
          ),
        );
      },
    );
  }

  Future submitTemperatureData() async {
    showLoading();
    var data = {
      'user_id': userId,
      'temperature': temperature,
      'companion_code': companionId,
    };
    print(data);
    try {
      var res = await Network()
          .authData(data, '/submit_temperature_and_fetch_user_data');
      var body = json.decode(res.body);
      if (body['success'] == true) {
        Navigator.pop(context);
        final snackBar = SnackBar(
          duration: Duration(seconds: 3),
          content: Container(
            height: 18.0,
            child: Padding(
              padding: EdgeInsets.only(left: 0, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Temperature submitted successfully',
                    style: TextStyle(fontSize: 15.0),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
          action: SnackBarAction(
              label: 'Close',
              textColor: Colors.white54,
              onPressed: () {
                _scaffoldKey.currentState.hideCurrentSnackBar();
              }),
          backgroundColor: Color.fromRGBO(236, 138, 92, 1),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
        Timer(Duration(seconds: 2), () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => QRExample()));
        });
      }
    } catch (e) {
      Navigator.pop(context);
      print(e.toString());
      final snackBar = SnackBar(
        duration: Duration(seconds: 3),
        content: Container(
          height: 18.0,
          child: Padding(
            padding: EdgeInsets.only(left: 0, right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Unable to submit temperature',
                  style: TextStyle(fontSize: 15.0),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
        action: SnackBarAction(
            label: 'Close',
            textColor: Colors.white54,
            onPressed: () {
              _scaffoldKey.currentState.hideCurrentSnackBar();
            }),
        backgroundColor: Color.fromRGBO(236, 138, 92, 1),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  Future submitAddress() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'user_id': userId,
      'barangay': b.text,
      'city': m.text,
      'province': p.text,
      'street': s.text,
      'phone': pn,
    };
    print(data);
    try {
      var res = await Network().authData(data, '/update_address');
      var body = json.decode(res.body);
      if (body['success'] == true) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
        final snackBar = SnackBar(
          duration: Duration(seconds: 3),
          content: Container(
            height: 18.0,
            child: Padding(
              padding: EdgeInsets.only(left: 0, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Address updated successfully',
                    style: TextStyle(fontSize: 15.0),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
          action: SnackBarAction(
              label: 'Close',
              textColor: Colors.white54,
              onPressed: () {
                _scaffoldKey.currentState.hideCurrentSnackBar();
              }),
          backgroundColor: Color.fromRGBO(236, 138, 92, 1),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      } else {
        setState(() {
          _isLoading = false;
        });
        print(body["message"]);
        Navigator.pop(context);
        final snackBar = SnackBar(
          duration: Duration(seconds: 3),
          content: Container(
            height: 18.0,
            child: Padding(
              padding: EdgeInsets.only(left: 0, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Unable to update address',
                    style: TextStyle(fontSize: 15.0),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
          action: SnackBarAction(
              label: 'Close',
              textColor: Colors.white54,
              onPressed: () {
                _scaffoldKey.currentState.hideCurrentSnackBar();
              }),
          backgroundColor: Color.fromRGBO(236, 138, 92, 1),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future submitCompanion() async {
    Navigator.pop(context);
    showLoading();
    setState(() {
      _isLoading = true;
    });
    var data = {
      'user_id': userId,
      'companion_first_name': companionFirstName,
      'companion_last_name': companionLastName,
      'companion_street': companionStreet.text,
      'companion_barangay': companionBarangay.text,
      'companion_municipality': companionCity.text,
      'companion_province': companionProvince.text,
      'companion_temperature': companionTemperature,
      'companion_contact_number': companionPhoneNumber,
      'companion_code': companionId,
    };
    print(data);
    try {
      var res = await Network().authData(data, '/add_companion');
      var body = json.decode(res.body);
      if (body['success'] == true) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
        showTemperature();
      } else {
        setState(() {
          _isLoading = false;
        });
        print(body["message"]);
        Navigator.pop(context);
        final snackBar = SnackBar(
          duration: Duration(seconds: 3),
          content: Container(
            height: 18.0,
            child: Padding(
              padding: EdgeInsets.only(left: 0, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Unable to add companion',
                    style: TextStyle(fontSize: 15.0),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
          action: SnackBarAction(
              label: 'Close',
              textColor: Colors.white54,
              onPressed: () {
                _scaffoldKey.currentState.hideCurrentSnackBar();
              }),
          backgroundColor: Color.fromRGBO(236, 138, 92, 1),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future _generateBarCode2(String inputCode) async {
    this.setState(() => this.bytes = inputCode);
    setState(() {
      isDone = true;
    });
    print(this.bytes);
  }

  Future _generateBarCode(String inputCode) async {
    this.setState(() => this.bytes = inputCode);
    if (indicator >= 7) {
      setState(() {
        isDone = true;
      });
      final snackBar = SnackBar(
        duration: Duration(seconds: 5),
        content: Container(
            height: 40.0,
            child: Center(
              child: Text(
                'Generated successfully',
                style: TextStyle(fontSize: 16.0),
              ),
            )),
        backgroundColor: Colors.greenAccent,
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
    print("isDone = " + isDone.toString());
  }

  Column widgetCompanion() {
    if (companionFirstName != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15),
          Text(
            "Companion Added:",
            textAlign: TextAlign.right,
            style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "$companionFirstName $companionLastName",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w300),
              ),
              Text(
                "$companionTemperature C",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w300),
              ),
            ],
          )
        ],
      );
    } else {
      return Column();
    }
  }

  showTemperature() async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: const EdgeInsets.all(20.0),
          content: new SingleChildScrollView(
            child: Form(
              key: _formKey2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  FlatButton(
                    height: 35,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side:
                            BorderSide(color: Color.fromRGBO(236, 138, 92, 1))),
                    color: Color.fromRGBO(236, 138, 92, 1),
                    textColor: Colors.white,
                    padding: EdgeInsets.all(8.0),
                    onPressed: () {
                      Navigator.pop(context);
                      addCompanion();
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add, size: 20.0),
                        Text(
                          'Add Companion',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  widgetCompanion(),
                  SizedBox(height: 15),
                  Text(
                    "Temperature",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Color.fromRGBO(21, 26, 70, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 15),
                  new TextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                    ],
                    autofocus: true,
                    obscureText: false,
                    onChanged: (value) {
                      print(value);
                      temperature = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'The field is required.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Enter your temperature",
                      labelStyle:
                          TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                      contentPadding: EdgeInsets.all(0.0),
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              height: 20,
              color: Colors.transparent,
              textColor: Color.fromRGBO(236, 138, 92, 1),
              padding: EdgeInsets.all(8.0),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            FlatButton(
              height: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(color: Color.fromRGBO(236, 138, 92, 1))),
              color: Color.fromRGBO(236, 138, 92, 1),
              textColor: Colors.white,
              padding: EdgeInsets.all(8.0),
              onPressed: () {
                if (_formKey2.currentState.validate()) {
                  Navigator.pop(context);
                  submitTemperatureData();
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }

  showUpdateAddress() async {
    await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                contentPadding: const EdgeInsets.all(20.0),
                content: new SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 0, right: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Update Profile",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(
                            top: 0.0,
                            bottom: 10.0,
                            left: 0.0,
                            right: 0.0,
                          ),
                          child: Text(
                            "Please fill up the required fields to be able to generate new QR code. We will not ask again next time.",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Province",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        new TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: InputDecoration(
                              labelText: "Select your province",
                              labelStyle: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.5)),
                              contentPadding: EdgeInsets.all(0.0),
                              hintStyle: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black54,
                              ),
                            ),
                            controller: p,
                          ),
                          suggestionsCallback: (pattern) {
                            return ProvinceService.getSuggestions(pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion),
                            );
                          },
                          transitionBuilder:
                              (context, suggestionsBox, controller) {
                            return suggestionsBox;
                          },
                          onSuggestionSelected: (suggestion) {
                            this.p.text = suggestion;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'The field is required.';
                            } else if (value.length < 4) {
                              return 'The field must be 4 characters.';
                            }
                            return null;
                          },
                          onSaved: (value) => this.p.text = value,
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "City / Municipality",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        new TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: InputDecoration(
                              labelText: "Select your city or municipality",
                              labelStyle: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.5)),
                              contentPadding: EdgeInsets.all(0.0),
                              hintStyle: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black54,
                              ),
                            ),
                            controller: m,
                          ),
                          suggestionsCallback: (pattern) {
                            return CitiesService.getSuggestions(pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion),
                            );
                          },
                          transitionBuilder:
                              (context, suggestionsBox, controller) {
                            return suggestionsBox;
                          },
                          onSuggestionSelected: (suggestion) {
                            this.m.text = suggestion;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'The field is required.';
                            } else if (value.length < 4) {
                              return 'The field must be 4 characters.';
                            }
                            return null;
                          },
                          onSaved: (value) => this.m.text = value,
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Barangay",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        new TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: InputDecoration(
                              labelText: "Select your barangay",
                              labelStyle: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.5)),
                              contentPadding: EdgeInsets.all(0.0),
                              hintStyle: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black54,
                              ),
                            ),
                            controller: b,
                          ),
                          suggestionsCallback: (pattern) {
                            return BarangayService.getSuggestions(pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion),
                            );
                          },
                          transitionBuilder:
                              (context, suggestionsBox, controller) {
                            return suggestionsBox;
                          },
                          onSuggestionSelected: (suggestion) {
                            this.b.text = suggestion;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'The field is required.';
                            } else if (value.length < 4) {
                              return 'The field must be 4 characters.';
                            }
                            return null;
                          },
                          onSaved: (value) => this.b.text = value,
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "House Unit No. / Street No. / Purok",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        new TextFormField(
                          initialValue: s.text,
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          onChanged: (value) {
                            s.text = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'The field is required.';
                            } else if (value.length < 4) {
                              return 'The field must be 4 characters.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Enter your house unit or street",
                            labelStyle:
                                TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                            contentPadding: EdgeInsets.all(0.0),
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Phone Number",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        new TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          autofocus: false,
                          onChanged: (value) {
                            pn = value;
                          },
                          maxLength: 11,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'The field is required.';
                            } else if (value.length < 11) {
                              return 'The field must be 11 characters.';
                            }

                            return null;
                          },
                          controller: pn == null
                              ? TextEditingController(text: "09")
                              : TextEditingController(text: pn),
                          decoration: InputDecoration(
                            labelText: "Enter your phone number",
                            labelStyle:
                                TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                            contentPadding: EdgeInsets.all(0.0),
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    height: 20,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side:
                            BorderSide(color: Color.fromRGBO(236, 138, 92, 1))),
                    color: Color.fromRGBO(236, 138, 92, 1),
                    textColor: Colors.white,
                    padding: EdgeInsets.all(8.0),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        submitAddress();
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ));
        });
  }

  addCompanion() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        contentPadding: const EdgeInsets.all(20.0),
        content: new SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Adding Companion",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            color: Color.fromRGBO(236, 138, 92, 1),
                            onPressed: () {
                              Navigator.pop(context);
                              showTemperature();
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "First Name",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    new TextFormField(
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      onChanged: (value) {
                        companionFirstName = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'The field is required.';
                        } else if (value.length < 4) {
                          return 'The field must be 4 characters.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Enter companion first name",
                        labelStyle:
                            TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                        contentPadding: EdgeInsets.all(0.0),
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      "Last Name",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    new TextFormField(
                      textInputAction: TextInputAction.next,
                      autofocus: false,
                      onChanged: (value) {
                        companionLastName = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'The field is required.';
                        } else if (value.length < 2) {
                          return 'The field must be 2 characters.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Enter companion last name",
                        labelStyle:
                            TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                        contentPadding: EdgeInsets.all(0.0),
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      "Province",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    new TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(
                          labelText: "Select companion province",
                          labelStyle:
                              TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                          contentPadding: EdgeInsets.all(0.0),
                          hintStyle: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black54,
                          ),
                        ),
                        controller: companionProvince,
                      ),
                      suggestionsCallback: (pattern) {
                        return ProvinceService.getSuggestions(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (suggestion) {
                        this.companionProvince.text = suggestion;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'The field is required.';
                        } else if (value.length < 4) {
                          return 'The field must be 4 characters.';
                        }
                        return null;
                      },
                      onSaved: (value) => this.companionProvince.text = value,
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      "City / Municipality",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    new TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(
                          labelText: "Select companion city or municipality",
                          labelStyle:
                              TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                          contentPadding: EdgeInsets.all(0.0),
                          hintStyle: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black54,
                          ),
                        ),
                        controller: companionCity,
                      ),
                      suggestionsCallback: (pattern) {
                        return CitiesService.getSuggestions(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (suggestion) {
                        this.companionCity.text = suggestion;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'The field is required.';
                        } else if (value.length < 4) {
                          return 'The field must be 4 characters.';
                        }
                        return null;
                      },
                      onSaved: (value) => this.companionCity.text = value,
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      "Barangay",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    new TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(
                          labelText: "Select companion barangay",
                          labelStyle:
                              TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                          contentPadding: EdgeInsets.all(0.0),
                          hintStyle: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black54,
                          ),
                        ),
                        controller: companionBarangay,
                      ),
                      suggestionsCallback: (pattern) {
                        return BarangayService.getSuggestions(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (suggestion) {
                        this.companionBarangay.text = suggestion;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'The field is required.';
                        } else if (value.length < 4) {
                          return 'The field must be 4 characters.';
                        }
                        return null;
                      },
                      onSaved: (value) => this.companionBarangay.text = value,
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      "House Unit No. / Street No. / Purok",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    new TextFormField(
                      initialValue: companionStreet.text,
                      textInputAction: TextInputAction.next,
                      autofocus: false,
                      onChanged: (value) {
                        companionStreet.text = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'The field is required.';
                        } else if (value.length < 4) {
                          return 'The field must be 4 characters.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText:
                            "Enter companion house unit or street or purok",
                        labelStyle:
                            TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                        contentPadding: EdgeInsets.all(0.0),
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      "Phone Number",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    new TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      autofocus: false,
                      onChanged: (value) {
                        companionPhoneNumber = value;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      maxLength: 11,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'The field is required.';
                        } else if (value.length < 11) {
                          return 'The field must be 11 characters.';
                        }

                        return null;
                      },
                      controller: TextEditingController(text: "09"),
                      decoration: InputDecoration(
                        labelText: "Enter companion phone number",
                        labelStyle:
                            TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                        contentPadding: EdgeInsets.all(0.0),
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      "Temperature",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    new TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                      ],
                      autofocus: false,
                      onChanged: (value) {
                        companionTemperature = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'The field is required.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Enter companion temperature",
                        labelStyle:
                            TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                        contentPadding: EdgeInsets.all(0.0),
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ])),
        ),
        actions: <Widget>[
          new FlatButton(
            height: 20,
            color: Colors.transparent,
            textColor: Color.fromRGBO(236, 138, 92, 1),
            padding: EdgeInsets.all(8.0),
            onPressed: () {
              Navigator.pop(context);
              showTemperature();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          new FlatButton(
            height: 20,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(color: Color.fromRGBO(236, 138, 92, 1))),
            color: Color.fromRGBO(236, 138, 92, 1),
            textColor: Colors.white,
            padding: EdgeInsets.all(8.0),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                submitCompanion();
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Add Companion',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Future checkExitTime() async {
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(oneSec, (Timer t) => print('hi!'));
  }

  @override
  void initState() {
    getProfile();
    // checkExitTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (merchantQrDataHasValue == true) {
      return Scaffold(
        key: _scaffoldKey,
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "10X ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(236, 138, 92, 1))),
                  TextSpan(
                      text: "Wait Lang",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(21, 26, 70, 1))),
                ]),
              ),
              SizedBox(height: 70),
              Center(
                child: Text(
                  "Success!",
                  style: TextStyle(
                      color: Color.fromRGBO(236, 138, 92, 1),
                      fontSize: 40,
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: 50),
              Center(
                child: Icon(Icons.check_circle_outline_sharp,
                    size: 200, color: Color.fromRGBO(21, 26, 70, 1)),
              ),
              SizedBox(height: 60),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: FlatButton(
                  height: 50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: Color.fromRGBO(236, 138, 92, 1))),
                  color: Color.fromRGBO(236, 138, 92, 1),
                  textColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  onPressed: () {},
                  child: Text(
                    "Okay",
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Center(
                child: Text(
                  "Wait Lang!",
                  style: TextStyle(
                      color: Color.fromRGBO(21, 26, 70, 1),
                      fontSize: 35,
                      fontWeight: FontWeight.w700),
                ),
              ),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "10X ",
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(236, 138, 92, 1))),
                  TextSpan(
                      text: "Digital Ledger",
                      style: TextStyle(
                          fontSize: 20, color: Color.fromRGBO(21, 26, 70, 1))),
                ]),
              ),
              SizedBox(
                height: 200,
                child: isDone
                    ? Center(
                        child: QrImage(
                        data: bytes,
                        version: QrVersions.auto,
                        size: 180,
                      ))
                    : Center(
                        child: Icon(Icons.qr_code,
                            size: 210, color: Color.fromRGBO(234, 86, 86, 1)),
                      ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // StepsIndicator(
              //   selectedStep: indicator,
              //   nbSteps: 7,
              //   selectedStepColorOut: Colors.blue,
              //   selectedStepColorIn: Colors.blue,
              //   doneStepColor: Colors.blue,
              //   unselectedStepColor: Colors.red,
              //   doneLineColor: Colors.blue,
              //   undoneLineColor: Colors.red,
              //   isHorizontal: true,
              //   lineLength: 40,
              //   lineThickness: 1,
              //   doneStepSize: 10,
              //   unselectedStepSize: 10,
              //   selectedStepSize: 10,
              //   selectedStepBorderSize: 1,
              // ),
              SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: isDone
                    ? Text("Success! Qr code generated for digital ledger",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Colors.greenAccent))
                    : Text(
                        "QR code will be generated if consent of user is granted",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Color.fromRGBO(236, 138, 92, 1)),
                      ),
              ),
              SizedBox(height: 28),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "I hereby authorize ",
                      style: TextStyle(
                          fontSize: 15, color: Color.fromRGBO(21, 26, 70, 1))),
                  TextSpan(
                      text: "10X Philippines ",
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(236, 138, 92, 1))),
                  TextSpan(
                      text:
                          "to collect my data indicated for the purpose of effecting control of COVID-19 infection. I understand that my personal information is protected by ",
                      style: TextStyle(
                          fontSize: 15, color: Color.fromRGBO(21, 26, 70, 1))),
                  TextSpan(
                      text: "RA 10173, Data Privacy Act of 2012.",
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(236, 138, 92, 1))),
                ]),
              ),

              SizedBox(height: 40),

              FlatButton(
                height: 50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(color: Color.fromRGBO(236, 138, 92, 1))),
                color: Color.fromRGBO(236, 138, 92, 1),
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                onPressed: () {
                  _generateBarCode2(rawJson.toString());
                  // showTemperature();
                },
                child: Text(
                  "Generate QR Code",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),

              SizedBox(height: 10),

              FlatButton(
                height: 50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(color: Color.fromRGBO(236, 138, 92, 1))),
                color: Colors.white,
                textColor: Color.fromRGBO(236, 138, 92, 1),
                padding: EdgeInsets.all(8.0),
                onPressed: () {
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => QRExample()));
                  showTemperature();
                },
                child: Text(
                  "Scan establishment QR Code",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),

              SizedBox(height: 30.0),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: isDone ? () => addCompanion() : null,
        //   //onPressed: () => addCompanion(),
        //   label: Text('Add Companion'),
        //   icon: Icon(Icons.add),
        //   backgroundColor: isDone ? Colors.pink : Colors.grey,
        // ),
      );
    }
  }
}

class QRExample extends StatefulWidget {
  QRExample({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _QRExampleState createState() => _QRExampleState();
}

class _QRExampleState extends State<QRExample> {
  GlobalKey qrKey = GlobalKey();
  QRViewController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: QRView(
          key: qrKey,
          overlay: QrScannerOverlayShape(
              borderRadius: 16,
              borderColor: Colors.white,
              borderLength: 120,
              borderWidth: 10,
              cutOutSize: 250),
          onQRViewCreated: _onQRViewCreate,
          data: "10X",
        ));
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreate(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        merchantQrData = scanData;
        merchantQrDataHasValue = true;
        dispose();
        Route route = MaterialPageRoute(builder: (context) => GenerateScreen());
        Navigator.pushReplacement(context, route);
      });
    });
  }
}
