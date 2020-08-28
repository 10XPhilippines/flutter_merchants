import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_merchants/network_utils/api.dart';
import 'package:flutter_merchants/screens/main_screen.dart';
import 'package:flutter_merchants/screens/otp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameControl = new TextEditingController();
  final TextEditingController _emailControl = new TextEditingController();
  final TextEditingController _phoneControl = new TextEditingController();
  final TextEditingController _passwordControl = new TextEditingController();
  final TextEditingController _passwordConfirmControl = new TextEditingController();
  bool _isButtonDisabled = false;
  var name;
  var phone;
  var email;
  var password;
  var passwordConfirm;
  bool _isLoading = false;
  String responseName = "Enter your name";
  String responsePhone = "Must include country code";
  String responseEmail = "Must be a valid email address";
  String responsePassword = "Enter your password";
  String responseConfirm = "Confirm your password";
  BuildContext _context;

  Future getFuture() {
    return Future(() async {
      await Future.delayed(Duration(seconds: 2));
      return 'Hello, Future Progress Dialog!';
    });
  }

  Future<void> showProgress(BuildContext context) async {
    await showDialog(
        context: context,
        child: FutureProgressDialog(getFuture(), message: Text('Loading...')));
  }

  void _register() async {
    setState(() {
      _isLoading = true;
      _isButtonDisabled = true;
    });
    var data = {
      'email': email,
      'password': password,
      'phone': phone,
      'name': name,
    };

    print(data);

    if (_passwordControl.text == _passwordConfirmControl.text) {}

    try {
      var res = await Network().authData(data, '/register');
      var body = json.decode(res.body);
      if (body['success']) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', json.encode(body['token']));
        localStorage.setString('user', json.encode(body['user']));
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              //return MainScreen();
              print("To otp");
              return OtpScreen();
            },
          ),
        );
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Failed"),
                content: Text("Error registering your details."),
                actions: <Widget>[
                  new FlatButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              );
            });
        setState(() {
          _isButtonDisabled = false;
          responseName = body["message"]["name"]
              .toString()
              .replaceAll(new RegExp(r'\['), '')
              .replaceAll(new RegExp(r'\]'), '');
          if (responseName == "null") {
            responseName = "Enter your name";
          }
          responsePhone = body["message"]["phone"]
              .toString()
              .replaceAll(new RegExp(r'\['), '')
              .replaceAll(new RegExp(r'\]'), '');
          if (responsePhone == "null") {
            responsePhone = "Must include country code";
          }
          responseEmail = body["message"]["email"]
              .toString()
              .replaceAll(new RegExp(r'\['), '')
              .replaceAll(new RegExp(r'\]'), '');
          if (responseEmail == "null") {
            responseEmail = "Must be a valid email address";
          }
          responsePassword = body["message"]["password"]
              .toString()
              .replaceAll(new RegExp(r'\['), '')
              .replaceAll(new RegExp(r'\]'), '');
          if (responsePassword == "null") {
            responsePassword = "Enter your password";
          }
        });
        print(body);
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        _isLoading = false;
      });
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

  _checkIfConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
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
    _checkIfConnected();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              top: 25.0,
            ),
            child: Text(
              "Create an account",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          SizedBox(height: 30.0),
          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: "Name",
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
                  hintText: responseName ?? "Enter your name",
                  // prefixIcon: Icon(
                  //   Icons.perm_identity,
                  //   color: Colors.black,
                  // ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black54,
                  ),
                ),
                maxLines: 1,
                controller: _usernameControl,
                onChanged: (value) {
                  name = value;
                },
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                  alignLabelWithHint: true,
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
                  hintText: responsePhone ?? "Must include country code",
                  // prefixIcon: Icon(
                  //   Icons.call,
                  //   color: Colors.black,
                  // ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black54,
                  ),
                ),
                maxLines: 1,
                controller: TextEditingController(text: "+63"),
                onChanged: (value) {
                  phone = value;
                },
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                  alignLabelWithHint: true,
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
                  hintText: responseEmail ?? "Must be a valid email address",
                  // prefixIcon: Icon(
                  //   Icons.mail_outline,
                  //   color: Colors.black,
                  // ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black54,
                  ),
                ),
                maxLines: 1,
                controller: _emailControl,
                onChanged: (value) {
                  email = value;
                },
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Password",
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
                  hintText: responsePassword ?? "Enter your password",
                  // prefixIcon: Icon(
                  //   Icons.lock_outline,
                  //   color: Colors.black,
                  // ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black54,
                  ),
                ),
                obscureText: true,
                maxLines: 1,
                controller: _passwordControl,
                onChanged: (value) {
                  password = value;
                },
              ),
            ),
          ),
          // SizedBox(height: 10.0),
          // Card(
          //   elevation: 3.0,
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(5.0),
          //       ),
          //     ),
          //     child: TextField(
          //       style: TextStyle(
          //         fontSize: 15.0,
          //         color: Colors.black,
          //       ),
          //       keyboardType: TextInputType.visiblePassword,
          //       decoration: InputDecoration(
          //         labelText: "Confirm Password",
          //         labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
          //         contentPadding: EdgeInsets.all(10.0),
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(5.0),
          //           borderSide: BorderSide(
          //             color: Colors.white,
          //           ),
          //         ),
          //         enabledBorder: OutlineInputBorder(
          //           borderSide: BorderSide(
          //             color: Colors.white,
          //           ),
          //           borderRadius: BorderRadius.circular(5.0),
          //         ),
          //         hintText: "Confirm your password",
          //         // prefixIcon: Icon(
          //         //   Icons.lock_outline,
          //         //   color: Colors.black,
          //         // ),
          //         hintStyle: TextStyle(
          //           fontSize: 15.0,
          //           color: Colors.black54,
          //         ),
          //       ),
          //       obscureText: true,
          //       maxLines: 1,
          //       controller: _passwordConfirmControl,
          //       onChanged: (value) {
          //         passwordConfirm = value;
          //       },
          //     ),
          //   ),
          // ),
          SizedBox(height: 40.0),
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            height: 50.0,
            child: RaisedButton(
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
                  : Text(
                      'Register'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
              onPressed: _isButtonDisabled ? null : () => _register(),
              color: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
          SizedBox(height: 10.0),
          // Divider(
          //   color: Theme.of(context).accentColor,
          // ),
          // SizedBox(height: 10.0),
          // SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
