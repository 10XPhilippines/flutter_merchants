import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter_merchants/screens/visits.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_merchants/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_select/smart_select.dart';

class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  String bytes;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
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
  String companionProvince;
  String companionCity;
  String companionStreet;
  String companionPhoneNumber;
  String companionTemperature;
  String companionBarangay;
  String e1, e2, e3, e4, e5, e6, e7, e8;
  String b, m, p, s, pn;
  bool hasAddress;
  var rawJson = ['Q1', 'Q2', 'Q3', 'Q4', 'Q5', 'Q6', 'Q7'];

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
    _generateBarCode(rawJson.toString());
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
        b = body["user"]["barangay"];
        p = body["user"]["province"];
        m = body["user"]["city"];
        s = body["user"]["street"];
        pn = body["user"]["phone"];
      });
    } else {
      setState(() {
        hasAddress = true;
      });
    }

    if (hasAddress == false) {
      updateAddress();
    }
  }

  Future submitAddress() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'user_id': userId,
      'barangay': b,
      'city': m,
      'province': p,
      'street': s,
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
          duration: Duration(seconds: 5),
          content: Container(
              height: 40.0,
              child: Center(
                child: Text(
                  'User data updated',
                  style: TextStyle(fontSize: 16.0),
                ),
              )),
          backgroundColor: Colors.greenAccent,
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      } else {
        setState(() {
          _isLoading = false;
        });
        print(body["message"]);
        Navigator.pop(context);
        final snackBar = SnackBar(
            duration: Duration(seconds: 5),
            content: Container(
                height: 40.0,
                child: Center(
                  child: Text(
                    'Unable to update',
                    style: TextStyle(fontSize: 16.0),
                  ),
                )),
            backgroundColor: Colors.redAccent);
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
    setState(() {
      _isLoading = true;
    });
    var data = {
      'user_id': userId,
      'companion_first_name': companionFirstName,
      'companion_last_name': companionLastName,
      'companion_street': companionStreet,
      'companion_barangay': companionBarangay,
      'companion_municipality': companionCity,
      'companion_province': companionProvince,
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
        final snackBar = SnackBar(
          duration: Duration(seconds: 5),
          content: Container(
              height: 40.0,
              child: Center(
                child: Text(
                  'Companion added: $companionFirstName $companionLastName',
                  style: TextStyle(fontSize: 16.0),
                ),
              )),
          backgroundColor: Colors.greenAccent,
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      } else {
        setState(() {
          _isLoading = false;
        });
        print(body["message"]);
        Navigator.pop(context);
        final snackBar = SnackBar(
            duration: Duration(seconds: 5),
            content: Container(
                height: 40.0,
                child: Center(
                  child: Text(
                    'Unable to add companion',
                    style: TextStyle(fontSize: 16.0),
                  ),
                )),
            backgroundColor: Colors.redAccent);
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
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

  updateAddress() async {
    await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: new AlertDialog(
                contentPadding: const EdgeInsets.all(16.0),
                content: new SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        new Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(
                            top: 12.0,
                            bottom: 12.0,
                            left: 0.0,
                            right: 0.0,
                          ),
                          child: Text(
                            "Update",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(
                            top: 10.0,
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
                        new TextFormField(
                          initialValue: p,
                          textInputAction: TextInputAction.next,
                          autofocus: true,
                          onChanged: (value) {
                            p = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'The field is required.';
                            } else if (value.length < 4) {
                              return 'The field must be at least 4 characters.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Province",
                            labelStyle:
                                TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: "Enter your province",
                            // prefixIcon: Icon(
                            //   Icons.perm_identity,
                            //   color: Colors.black,
                            // ),
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        new TextFormField(
                          initialValue: m,
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          onChanged: (value) {
                            m = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'The field is required.';
                            } else if (value.length < 4) {
                              return 'The field must be at least 4 characters.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "City / Municipality",
                            labelStyle:
                                TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: "Enter your municipality",
                            // prefixIcon: Icon(
                            //   Icons.perm_identity,
                            //   color: Colors.black,
                            // ),
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        new TextFormField(
                          initialValue: b,
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          onChanged: (value) {
                            b = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'The field is required.';
                            } else if (value.length < 4) {
                              return 'The field must be at least 4 characters.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Barangay",
                            labelStyle:
                                TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: "Enter your barangay",
                            // prefixIcon: Icon(
                            //   Icons.perm_identity,
                            //   color: Colors.black,
                            // ),
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        new TextFormField(
                          initialValue: s,
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          onChanged: (value) {
                            s = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'The field is required.';
                            } else if (value.length < 4) {
                              return 'The field must be at least 4 characters.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "House Unit / Street",
                            labelStyle:
                                TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: "Enter your house unit or street",
                            // prefixIcon: Icon(
                            //   Icons.perm_identity,
                            //   color: Colors.black,
                            // ),
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        new TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          autofocus: false,
                          onChanged: (value) {
                            pn = value;
                          },
                          maxLength: 11,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'The field is required.';
                            } else if (value.length < 11) {
                              return 'The field must be at least 11 characters.';
                            }

                            return null;
                          },
                          controller: pn == null
                              ? TextEditingController(text: "09")
                              : TextEditingController(text: pn),
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            labelStyle:
                                TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: "Enter your phone number",
                            // prefixIcon: Icon(
                            //   Icons.perm_identity,
                            //   color: Colors.black,
                            // ),
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
                      child: _isLoading
                          ? SizedBox(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                strokeWidth: 2.0,
                              ),
                              height: 15.0,
                              width: 15.0,
                            )
                          : Text('Save'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          print("Submit");
                          submitAddress();
                        }
                      })
                ],
              ));
        });
  }

  addCompanion() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                new Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(
                    top: 12.0,
                    bottom: 12.0,
                    left: 0.0,
                    right: 0.0,
                  ),
                  child: Text(
                    "Companion",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
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
                      return 'The field must be at least 4 characters.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "First Name",
                    labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Enter companion first name",
                    // prefixIcon: Icon(
                    //   Icons.perm_identity,
                    //   color: Colors.black,
                    // ),
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
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
                      return 'The field must be at least 2 characters.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Last Name",
                    labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Enter companion last name",
                    // prefixIcon: Icon(
                    //   Icons.perm_identity,
                    //   color: Colors.black,
                    // ),
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                new TextFormField(
                  textInputAction: TextInputAction.next,
                  autofocus: false,
                  onChanged: (value) {
                    companionProvince = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'The field is required.';
                    } else if (value.length < 4) {
                      return 'The field must be at least 4 characters.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Province",
                    labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Enter companion province",
                    // prefixIcon: Icon(
                    //   Icons.perm_identity,
                    //   color: Colors.black,
                    // ),
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                new TextFormField(
                  textInputAction: TextInputAction.next,
                  autofocus: false,
                  onChanged: (value) {
                    companionCity = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'The field is required.';
                    } else if (value.length < 4) {
                      return 'The field must be at least 4 characters.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "City / Municipality",
                    labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Enter companion municipality",
                    // prefixIcon: Icon(
                    //   Icons.perm_identity,
                    //   color: Colors.black,
                    // ),
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                new TextFormField(
                  textInputAction: TextInputAction.next,
                  autofocus: false,
                  onChanged: (value) {
                    companionBarangay = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'The field is required.';
                    } else if (value.length < 4) {
                      return 'The field must be at least 4 characters.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Barangay",
                    labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Enter companion barangay",
                    // prefixIcon: Icon(
                    //   Icons.perm_identity,
                    //   color: Colors.black,
                    // ),
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                new TextFormField(
                  textInputAction: TextInputAction.next,
                  autofocus: false,
                  onChanged: (value) {
                    companionStreet = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'The field is required.';
                    } else if (value.length < 4) {
                      return 'The field must be at least 4 characters.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "House Unit / Street",
                    labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Enter companion house unit or street",
                    // prefixIcon: Icon(
                    //   Icons.perm_identity,
                    //   color: Colors.black,
                    // ),
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                new TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  autofocus: false,
                  onChanged: (value) {
                    companionPhoneNumber = value;
                  },
                  maxLength: 11,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'The field is required.';
                    } else if (value.length < 11) {
                      return 'The field must be at least 11 characters.';
                    }

                    return null;
                  },
                  controller: TextEditingController(text: "09"),
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Enter companion phone number",
                    // prefixIcon: Icon(
                    //   Icons.perm_identity,
                    //   color: Colors.black,
                    // ),
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                new TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
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
                    labelText: "Temperature",
                    labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Enter companion temperature",
                    // prefixIcon: Icon(
                    //   Icons.perm_identity,
                    //   color: Colors.black,
                    // ),
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
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: _isLoading
                  ? SizedBox(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 2.0,
                      ),
                      height: 15.0,
                      width: 15.0,
                    )
                  : Text('Add Companion'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  submitCompanion();
                }
              })
        ],
      ),
    );
  }

  @override
  void initState() {
    getProfile();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Wait Lang!",
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.history),
            iconSize: 20,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return VisitScreen();
                  },
                ),
              );
            },
            tooltip: "Save",
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(
              height: 190,
              child: isDone
                  ? Center(
                      child: QrImage(
                      data: bytes,
                      version: QrVersions.auto,
                      size: 200.0,
                    ))
                  : Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: ExactAssetImage('assets/806700.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
            ),
            SizedBox(
              height: 30,
              child: isDone
                  ? Text(
                      "Merchant will scan this generated\ndynamic code",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
                    )
                  : Text(
                      "Complete the survey first to generate\na dynamic code",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
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
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                top: 25.0,
                left: 12.0,
              ),
              child: Text(
                "Required Questions",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                top: 20.0,
                left: 12.0,
                right: 12.0,
              ),
              child: Text(
                "All information submitted shall be encrypted, and strictly used only in compliance to the Philippine law, guidelines, and ordinances, in relation to business operation in light of COVID-19 responses.",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black45,
                ),
              ),
            ),

            SizedBox(height: 10.0),
            SmartSelect<String>.single(
                title: 'Do you have sore throat?',
                value: soreThroat,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => {
                      setState(() {
                        soreThroat = val;
                        if (rawJson[2] == "Q1") {
                          indicator += 1;
                        }
                        if (rawJson.asMap().containsKey(2) == false) {
                          rawJson.insert(2, val);
                        } else {
                          rawJson.removeAt(2);
                          rawJson.insert(2, val);
                        }
                        print(rawJson);
                        print(rawJson.asMap().containsKey(2));
                        _generateBarCode(rawJson.toString());
                      })
                    }),
            SizedBox(height: 10.0),
            SmartSelect<String>.single(
                title: 'Do you have headache?',
                value: headAche,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => {
                      setState(() {
                        if (rawJson[3] == "Q2") {
                          indicator += 1;
                        }
                        headAche = val;
                        if (rawJson.asMap().containsKey(3) == false) {
                          rawJson.insert(3, val);
                        } else {
                          rawJson.removeAt(3);
                          rawJson.insert(3, val);
                        }
                        print(rawJson);
                        print(rawJson.asMap().containsKey(3));
                        _generateBarCode(rawJson.toString());
                      })
                    }),
            SizedBox(height: 10.0),
            SmartSelect<String>.single(
                title: 'Do you have fever?',
                value: fever,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => {
                      setState(() {
                        if (rawJson[4] == "Q3") {
                          indicator += 1;
                        }
                        fever = val;
                        if (rawJson.asMap().containsKey(4) == false) {
                          rawJson.insert(4, val);
                        } else {
                          rawJson.removeAt(4);
                          rawJson.insert(4, val);
                        }
                        print(rawJson);
                        print(rawJson.asMap().containsKey(4));
                        _generateBarCode(rawJson.toString());
                      })
                    }),
            SizedBox(height: 10.0),
            SmartSelect<String>.single(
                title: 'Do you have travel history?',
                value: travelHistory,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => {
                      setState(() {
                        if (rawJson[5] == "Q4") {
                          indicator += 1;
                        }
                        travelHistory = val;
                        if (rawJson.asMap().containsKey(5) == false) {
                          rawJson.insert(5, val);
                        } else {
                          rawJson.removeAt(5);
                          rawJson.insert(5, val);
                        }
                        print(rawJson);
                        print(rawJson.asMap().containsKey(5));
                        _generateBarCode(rawJson.toString());
                      })
                    }),
            SizedBox(height: 10.0),
            SmartSelect<String>.single(
                title: 'Do you have exposure?',
                value: exposure,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => {
                      setState(() {
                        if (rawJson[6] == "Q5") {
                          indicator += 1;
                        }
                        exposure = val;
                        if (rawJson.asMap().containsKey(6) == false) {
                          rawJson.insert(6, val);
                        } else {
                          rawJson.removeAt(6);
                          rawJson.insert(6, val);
                        }
                        print(rawJson);
                        print(rawJson.asMap().containsKey(6));
                        _generateBarCode(rawJson.toString());
                      })
                    }),
            SizedBox(height: 10.0),
            SmartSelect<String>.single(
                title: 'Do you have cough or colds?',
                value: cough,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => {
                      setState(() {
                        if (rawJson[7] == "Q6") {
                          indicator += 1;
                        }
                        cough = val;
                        if (rawJson.asMap().containsKey(7) == false) {
                          rawJson.insert(7, val);
                        } else {
                          rawJson.removeAt(7);
                          rawJson.insert(7, val);
                        }
                        print(rawJson);
                        print(rawJson.asMap().containsKey(7));
                        _generateBarCode(rawJson.toString());
                      })
                    }),
            SizedBox(height: 10.0),
            SmartSelect<String>.single(
                title: 'Do you have body pain?',
                value: bodyPain,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => {
                      setState(() {
                        if (rawJson[8] == "Q7") {
                          indicator += 1;
                        }
                        bodyPain = val;
                        if (rawJson.asMap().containsKey(8) == false) {
                          rawJson.insert(8, val);
                        } else {
                          rawJson.removeAt(8);
                          rawJson.insert(8, val);
                        }
                        print(rawJson);
                        print(rawJson.asMap().containsKey(8));
                        _generateBarCode(rawJson.toString());
                      })
                    }),
            SizedBox(height: 80.0),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isDone ? () => addCompanion() : null,
        //onPressed: () => addCompanion(),
        label: Text('Add Companion'),
        icon: Icon(Icons.add),
        backgroundColor: isDone ? Colors.pink : Colors.grey,
      ),
    );
  }
}
