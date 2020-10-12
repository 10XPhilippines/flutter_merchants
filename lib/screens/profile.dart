import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_merchants/screens/splash.dart';
import 'package:flutter_merchants/screens/otp.dart';
import 'package:flutter_merchants/screens/default_business.dart';
import 'package:flutter_merchants/screens/survey.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_merchants/network_utils/api.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map profile = {};
  String data = "";
  int userId = 0;
  String isVerified = "0";
  bool hasConnection = false;
  String path = "";
  BuildContext _context;
  bool _isLoading = false;
  String userType;
  String image;
  String b, m, p, s, pn, fn, ln;

  getProfile() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    data = preferences.getString("user");
    setState(() {
      profile = json.decode(data);
      userType = profile["user_type"];
      isVerified = profile["is_verified"].toString();
      userId = int.parse(profile["id"].toString());
      path = Network().qrCode() + "/code/" + profile["user_barcode_path"];
      image = Network().qrCode() + profile["image"];
      print(image);
      _isLoading = false;
    });
    getUserData(userId.toString());
  }

  resendOtp() async {
    setState(() {
      _isLoading = true;
    });
    final input = {'id': userId};
    print(input);
    _checkIfConnected();

    if (hasConnection == true) {
      final res = await Network().authData(input, '/resend');
      final body = json.decode(res.body);
      if (body['success']) {
        print('Debug OTP resend');
        print(userId);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return OtpScreen();
            },
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      final snackBar = SnackBar(
        duration: Duration(seconds: 5),
        content: Container(
            height: 40.0,
            child: Center(
              child: Text(
                'Network is unreachable',
                style: TextStyle(fontSize: 16.0),
              ),
            )),
        backgroundColor: Colors.redAccent,
      );
      Scaffold.of(_context).hideCurrentSnackBar();
      Scaffold.of(_context).showSnackBar(snackBar);
    }
  }

  void logout() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final res = await Network().getData('/logout');
      final body = json.decode(res.body);
      if (body['success']) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.remove('user');
        localStorage.remove('token');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return SplashScreen();
            },
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e.toString());
      final snackBar = SnackBar(
        duration: Duration(seconds: 5),
        content: Container(
            height: 40.0,
            child: Center(
              child: Text(
                'Network is unreachable',
                style: TextStyle(fontSize: 16.0),
              ),
            )),
        backgroundColor: Colors.redAccent,
      );
      Scaffold.of(_context).hideCurrentSnackBar();
      Scaffold.of(_context).showSnackBar(snackBar);
      setState(() {
        _isLoading = false;
      });
    }
  }

  _checkIfConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        setState(() {
          hasConnection = true;
        });
        getProfile();
      }
    } on SocketException catch (_) {
      setState(() {
        hasConnection = false;
      });
      final snackBar = SnackBar(
        duration: Duration(seconds: 5),
        content: Container(
            height: 40.0,
            child: Center(
              child: Text(
                'No connection',
                style: TextStyle(fontSize: 16.0),
              ),
            )),
        backgroundColor: Colors.redAccent,
      );
      Scaffold.of(_context).hideCurrentSnackBar();
      Scaffold.of(_context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    print("Initstate");
    getProfile();
    _checkIfConnected();
    super.initState();
  }

  Future getUserData(String id) async {
    var res = await Network().getData('/user/' + id.toString());
    var body = json.decode(res.body);
    print(body);
    setState(() {
      b = body["user"]["barangay"];
      p = body["user"]["province"];
      m = body["user"]["city"];
      s = body["user"]["street"];
      pn = body["user"]["phone"];
      fn = body["user"]["first_name"];
      ln = body["user"]["last_name"];
    });
  }

  updateProfile() async {
    var data = {
      'user_id': userId,
      'first_name': fn,
      'last_name': ln,
      'barangay': b,
      'city': m,
      'province': p,
      'street': s,
      'phone': pn,
    };
    print(data);
    try {
      var res = await Network().authData(data, '/update_profile');
      var body = json.decode(res.body);
      if (body['success'] == true) {
        Navigator.pop(context);
        getUserData(userId.toString());
        final snackBar = SnackBar(
          duration: Duration(seconds: 5),
          content: Container(
              height: 40.0,
              child: Center(
                child: Text(
                  'User profile updated',
                  style: TextStyle(fontSize: 16.0),
                ),
              )),
          backgroundColor: Colors.greenAccent,
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      } else {
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

  updateAddress() async {
    await showDialog<String>(
        context: context,
        barrierDismissible: false,
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
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  new TextFormField(
                    initialValue: fn,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    onChanged: (value) {
                      fn = value;
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
                      hintText: "Enter your first name",
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
                    initialValue: ln,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    onChanged: (value) {
                      ln = value;
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
                      hintText: "Enter your last name",
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
                child: Text('Cancel'),
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
                    : Text('Save'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    print("Submit");
                    updateProfile();
                  }
                })
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: _isLoading
              ? <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 2.0,
                      ),
                      height: 15.0,
                      width: 15.0,
                    ),
                  )
                ]
              : <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: new CircleAvatar(
                          backgroundImage: NetworkImage(
                            image ??
                                "https://img.icons8.com/fluent/48/000000/user-male-circle.png",
                          ),
                          radius: 50.0,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                fn == null || ln == null
                                    ? Text(
                                        profile["name"],
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Text(
                                        "$fn $ln",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                isVerified == "1"
                                    ? Icon(
                                        Icons.verified_user,
                                        color: Colors.green,
                                      )
                                    : Icon(Icons.verified_user,
                                        color: Colors.red),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  profile["email"] ?? "No data",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: _isLoading
                                  ? <Widget>[
                                      Center(
                                        child: SizedBox(
                                          child: CircularProgressIndicator(
                                            backgroundColor: Colors.white,
                                            strokeWidth: 2.0,
                                          ),
                                          height: 15.0,
                                          width: 15.0,
                                        ),
                                      )
                                    ]
                                  : <Widget>[
                                      isVerified == "0"
                                          ? InkWell(
                                              onTap: () {
                                                resendOtp();
                                              },
                                              child: Text(
                                                "Tap to verify account",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                print("profile test");
                                                updateAddress();
                                              },
                                              child: Text(
                                                "Tap to edit profile",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.blue,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                    ],
                            ),
                          ],
                        ),
                        flex: 3,
                      ),
                    ],
                  ),
                  // Divider(),
                  Container(height: 15.0),
                  Padding(
                    padding: EdgeInsets.all(0.0),
                    child: ListTile(
                      title: Text(
                        "Account Information".toUpperCase(),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // trailing: IconButton(
                      //   icon: Icon(
                      //     Icons.mode_edit,
                      //     size: 20.0,
                      //   ),
                      //   onPressed: () {
                      //     _showDialog();
                      //   },
                      //   tooltip: "Edit",
                      // ),
                    ),
                  ),

                  ListTile(
                    title: Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: fn == null || ln == null
                        ? Text(
                            profile["name"],
                          )
                        : Text("$fn $ln"),
                  ),
                  ListTile(
                    title: Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      profile["email"] ?? "No data available",
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Phone",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      "$pn",
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Type",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      toBeginningOfSentenceCase(userType) ??
                          "No data available",
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Address",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      "$s, $b, $m, $p" ?? "No data available",
                    ),
                  ),
                  // ListTile(
                  //   title: Text(
                  //     "Gender",
                  //     style: TextStyle(
                  //       fontSize: 17,
                  //       fontWeight: FontWeight.w700,
                  //     ),
                  //   ),
                  //   subtitle: Text(
                  //     profile["sex"] ?? "No data available",
                  //   ),
                  // ),
                  // Divider(),
                  // ListTile(
                  //   onTap: () {
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(
                  //         builder: (BuildContext context) {
                  //           return ChangeEmailScreen();
                  //         },
                  //       ),
                  //     );
                  //   },
                  //   title: Text(
                  //     "Change email",
                  //     style: TextStyle(
                  //       fontSize: 17,
                  //       fontWeight: FontWeight.w700,
                  //     ),
                  //   ),
                  //   subtitle: Text(
                  //     'Update your email',
                  //   ),
                  //   // trailing: Text(
                  //   //   'Edit',
                  //   // ),
                  // ),
                  // ListTile(
                  //   title: Text(
                  //     "Change password",
                  //     style: TextStyle(
                  //       fontSize: 17,
                  //       fontWeight: FontWeight.w700,
                  //     ),
                  //   ),
                  //   subtitle: Text(
                  //     'Update your password',
                  //   ),
                  //   // trailing: Text(
                  //   //   'Edit',
                  //   // ),
                  // ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return DefaultBusinessScreen();
                          },
                        ),
                      );
                    },
                    title: Text(
                      "Business",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      'Choose default business',
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.store,
                        size: 20.0,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return DefaultBusinessScreen();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return SurveyScreen();
                          },
                        ),
                      );
                    },
                    title: Text(
                      "Survey Form",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      'Answer surveys and generate QR',
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.question_answer,
                        size: 20.0,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return SurveyScreen();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  // Divider(),
                  // ListTile(
                  //   onTap: () {
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(
                  //         builder: (BuildContext context) {
                  //           return HistoryScreen();
                  //         },
                  //       ),
                  //     );
                  //   },
                  //   title: Text(
                  //     "History",
                  //     style: TextStyle(
                  //       fontSize: 17,
                  //       fontWeight: FontWeight.w700,
                  //     ),
                  //   ),
                  //   subtitle: Text(
                  //     'View list of scanned customer',
                  //   ),
                  //   trailing: IconButton(
                  //     icon: Icon(
                  //       Icons.history,
                  //       size: 20.0,
                  //     ),
                  //     onPressed: () {
                  //       Navigator.of(context).push(
                  //         MaterialPageRoute(
                  //           builder: (BuildContext context) {
                  //             return HistoryScreen();
                  //           },
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Logout"),
                              content: Text("You are about to logout."),
                              actions: <Widget>[
                                new FlatButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                                new FlatButton(
                                    child: _isLoading
                                        ? Center(
                                            child: SizedBox(
                                              child: CircularProgressIndicator(
                                                backgroundColor: Colors.white,
                                                strokeWidth: 2.0,
                                              ),
                                              height: 15.0,
                                              width: 15.0,
                                            ),
                                          )
                                        : const Text('Logout'),
                                    onPressed: () {
                                      logout();
                                    })
                              ],
                            );
                          });
                    },
                    title: Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      'Logout to your account',
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.redAccent,
                        size: 20.0,
                      ),
                      onPressed: () {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Logout"),
                                content: Text("You are about to logout."),
                                actions: <Widget>[
                                  new FlatButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                  new FlatButton(
                                      child: _isLoading
                                          ? Center(
                                              child: SizedBox(
                                                child:
                                                    CircularProgressIndicator(
                                                  backgroundColor: Colors.white,
                                                  strokeWidth: 2.0,
                                                ),
                                                height: 15.0,
                                                width: 15.0,
                                              ),
                                            )
                                          : const Text('Logout'),
                                      onPressed: () {
                                        logout();
                                      })
                                ],
                              );
                            });
                      },
                      tooltip: "Edit",
                    ),
                  ),

                  SizedBox(height: 80.0),
                  // MediaQuery.of(context).platformBrightness == Brightness.dark
                  //     ? SizedBox()
                  //     : ListTile(
                  //         title: Text(
                  //           "Dark Theme",
                  //           style: TextStyle(
                  //             fontSize: 17,
                  //             fontWeight: FontWeight.w700,
                  //           ),
                  //         ),
                  //         trailing: Switch(
                  //           value: Provider.of<AppProvider>(context).theme ==
                  //                   Constants.lightTheme
                  //               ? false
                  //               : true,
                  //           onChanged: (v) async {
                  //             if (v) {
                  //               Provider.of<AppProvider>(context, listen: false)
                  //                   .setTheme(Constants.darkTheme, "dark");
                  //             } else {
                  //               Provider.of<AppProvider>(context, listen: false)
                  //                   .setTheme(Constants.lightTheme, "light");
                  //             }
                  //           },
                  //           activeColor: Theme.of(context).accentColor,
                  //         ),
                  //       ),
                ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     showDialog(
      //         barrierDismissible: false,
      //         context: context,
      //         builder: (BuildContext context) {
      //           return AlertDialog(
      //             content: hasConnection
      //                 ? Image.network(path)
      //                 : Text(
      //                     "Unable to fetch code. There is no internet connection.",
      //                     textAlign: TextAlign.center,
      //                   ),
      //             actions: <Widget>[
      //               new FlatButton(
      //                   child: const Text('Export'),
      //                   onPressed: () {
      //                     Navigator.pop(context);
      //                   }),
      //               new FlatButton(
      //                   child: const Text('Close'),
      //                   onPressed: () {
      //                     Navigator.pop(context);
      //                   })
      //             ],
      //           );
      //         });
      //   },
      //   label: Text('My QR'),
      //   icon: Icon(Icons.camera),
      //   backgroundColor: Colors.pink,
      // ),
    );
  }
}
