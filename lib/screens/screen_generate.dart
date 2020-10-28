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
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_merchants/models/province.dart';
import 'package:flutter_merchants/models/city.dart';
import 'package:flutter_merchants/models/barangay.dart';

class GenerateScreen extends StatefulWidget {
  @override
  _GenerateScreenState createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  String bytes;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
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
  String pn;
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
      updateAddress();
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

  Future _generateBarCode2(String inputCode) async {
    this.setState(() => this.bytes = inputCode);
    setState(() {
      isDone = true;
    });
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
                        new TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: InputDecoration(
                              labelText: "Province",
                              labelStyle: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.5)),
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
                              return 'The field must be at least 4 characters.';
                            }
                            return null;
                          },
                          onSaved: (value) => this.p.text = value,
                        ),
                        SizedBox(height: 15.0),
                        new TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: InputDecoration(
                              labelText: "City / Municipality",
                              labelStyle: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.5)),
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
                              hintText: "Enter your city or municipality",
                              // prefixIcon: Icon(
                              //   Icons.perm_identity,
                              //   color: Colors.black,
                              // ),
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
                              return 'The field must be at least 4 characters.';
                            }
                            return null;
                          },
                          onSaved: (value) => this.m.text = value,
                        ),
                        SizedBox(height: 15.0),
                        new TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: InputDecoration(
                              labelText: "Barangay",
                              labelStyle: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.5)),
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
                              return 'The field must be at least 4 characters.';
                            }
                            return null;
                          },
                          onSaved: (value) => this.b.text = value,
                        ),
                        SizedBox(height: 15.0),
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
                new TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
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
                      return 'The field must be at least 4 characters.';
                    }
                    return null;
                  },
                  onSaved: (value) => this.companionProvince.text = value,
                ),
                SizedBox(height: 15.0),
                new TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
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
                      hintText: "Enter companion city or municipality",
                      // prefixIcon: Icon(
                      //   Icons.perm_identity,
                      //   color: Colors.black,
                      // ),
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
                      return 'The field must be at least 4 characters.';
                    }
                    return null;
                  },
                  onSaved: (value) => this.companionCity.text = value,
                ),
                SizedBox(height: 15.0),
                new TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
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
                      return 'The field must be at least 4 characters.';
                    }
                    return null;
                  },
                  onSaved: (value) => this.companionBarangay.text = value,
                ),
                SizedBox(height: 15.0),
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
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   leading: IconButton(
      //     icon: Icon(
      //       Icons.keyboard_backspace,
      //     ),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   centerTitle: true,
      //   title: Text(
      //     "Wait Lang!",
      //   ),
      //   elevation: 0.0,
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(Icons.history),
      //       iconSize: 20,
      //       onPressed: () {
      //         Navigator.of(context).push(
      //           MaterialPageRoute(
      //             builder: (BuildContext context) {
      //               return VisitScreen();
      //             },
      //           ),
      //         );
      //       },
      //       tooltip: "Save",
      //     ),
      //   ],
      // ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 0),
        child: ListView(
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
                        fontSize: 20, color: Color.fromRGBO(236, 138, 92, 1))),
                TextSpan(
                    text: "Digital Ledger",
                    style: TextStyle(
                        fontSize: 20, color: Color.fromRGBO(21, 26, 70, 1))),
              ]),
            ),
            SizedBox(
              height: 200,
              child: isDone
                  ? 
                  Center(
                      child: QrImage(
                      data: bytes,
                      version: QrVersions.auto,
                      size: 180,
                    ))
                  : Center(
                      child: Icon(Icons.qr_code,
                          size: 220, color: Color.fromRGBO(234, 86, 86, 1)),
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
              height: 13,
              child: isDone
                  ? Text(
                      "Merchant will scan this generated dynamic code",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Color.fromRGBO(236, 138, 92, 1)),
                    )
                  : Text(
                      "QR code will be generated if consent of user is granted",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13,
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
                        fontSize: 15, color: Color.fromRGBO(236, 138, 92, 1))),
                TextSpan(
                    text:
                        "to collect my data indicated for the purpose of effecting control of COVID-19 infection. I understand that my personal information is protected by ",
                    style: TextStyle(
                        fontSize: 15, color: Color.fromRGBO(21, 26, 70, 1))),
                TextSpan(
                    text: "RA 10173, Data Privacy Act of 2012.",
                    style: TextStyle(
                        fontSize: 15, color: Color.fromRGBO(236, 138, 92, 1))),
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
              onPressed: () {},
              child: Text(
                "Scan establishment QR Code",
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),

            SizedBox(height: 80.0),
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
