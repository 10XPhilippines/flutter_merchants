import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_merchants/network_utils/api.dart';
import 'package:flutter_merchants/screens/main_screen.dart';
import 'package:flutter_merchants/screens/screen_signup.dart';
import 'package:flutter_merchants/screens/screen_forgot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen>
    with AutomaticKeepAliveClientMixin<SigninScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  var email;
  var password;
  Map profile = {};
  bool _isLoading = false;
  bool _isButtonDisabled = false;
  BuildContext _context;
  String message;

  void _login() async {
    setState(() {
      _isLoading = true;
      _isButtonDisabled = true;
    });

    var data = {'email': email, 'password': password};

    print(data);

    try {
      var res = await Network().authData(data, '/login');
      var body = json.decode(res.body);
      if (body['success']) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', json.encode(body['token']));
        localStorage.setString('user', json.encode(body['user']));
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return MainScreen();
            },
          ),
        );
      } else {
        setState(() {
          message = body['message'];
          _isButtonDisabled = false;
        });
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                // title: Text("Login failed"),
                content: Text("$message Please try again."),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                contentPadding: const EdgeInsets.all(20.0),
                actions: <Widget>[
                  new FlatButton(
                      height: 20,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(
                              color: Color.fromRGBO(236, 138, 92, 1))),
                      color: Color.fromRGBO(236, 138, 92, 1),
                      textColor: Colors.white,
                      padding: EdgeInsets.all(8.0),
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              );
            });
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e.toString());
      Toast.show("Network is unreachable", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      // final snackBar = SnackBar(
      //   duration: Duration(seconds: 5),
      //   content: Container(
      //       height: 30.0,
      //       child: Center(
      //         child: Text(
      //           'Network is unreachable',
      //           style: TextStyle(fontSize: 10.0),
      //         ),
      //       )),
      //   backgroundColor: Color.fromRGBO(236, 138, 92, 1),
      // );
      // Scaffold.of(_context).hideCurrentSnackBar();
      // Scaffold.of(_context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Padding(
        padding: EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Center(
              child: Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/logo.png',
                    width: 120,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                "Sign In",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 30),
            FlatButton(
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(
                      width: 2.0, color: Color.fromRGBO(236, 138, 92, 1))),
              color: Colors.white,
              textColor: Color.fromRGBO(236, 138, 92, 1),
              padding: EdgeInsets.only(left: 30, right: 30),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // IconButton(
                  //     icon: Icon(Icons.g_translate),
                  //     color: Colors.blue,
                  //     onPressed: () {}),
                  Image.asset(
                    'assets/fb.png',
                    height: 25,
                  ),
                  Text(
                    "Continue with Facebook",
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            FlatButton(
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(
                      width: 2.0, color: Color.fromRGBO(236, 138, 92, 1))),
              color: Colors.white,
              textColor: Color.fromRGBO(236, 138, 92, 1),
              padding: EdgeInsets.only(left: 30, right: 30),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/google.png',
                    height: 25,
                  ),
                  Text(
                    "Continue with Google",
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Row(children: <Widget>[
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 0.0, right: 10.0),
                    child: Divider(
                      color: Colors.black,
                      height: 50,
                    )),
              ),
              Text("OR"),
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 0.0),
                    child: Divider(
                      color: Colors.black,
                      height: 50,
                    )),
              ),
            ]),
            SizedBox(height: 15),
            SizedBox(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0, 10.0, 0),
                          child: Text(
                            "Email Address",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          )),
                    ),
                    new TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: true,
                      onChanged: (value) {
                        email = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'The field is required.';
                        } else if (value.length < 4) {
                          return 'The field must be at least 6 characters.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Enter your email address",
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
                    SizedBox(
                      height: 30,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0, 10.0, 0),
                          child: Text(
                            "Password",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          )),
                    ),
                    new TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'The field is required.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Enter your password",
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
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return ForgotScreen();
                            },
                          ),
                        );
                      },
                      child: Text(
                        'Forgot password?',
                        style:
                            TextStyle(color: Color.fromRGBO(236, 138, 92, 1)),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    _isLoading
                        ? FlatButton(
                            height: 50,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                side: BorderSide(
                                    color: Color.fromRGBO(236, 138, 92, 1))),
                            color: Color.fromRGBO(236, 138, 92, 1),
                            textColor: Colors.white,
                            padding: EdgeInsets.all(8.0),
                            onPressed: null,
                            child: Center(
                              child: SizedBox(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  strokeWidth: 2.0,
                                ),
                                height: 15.0,
                                width: 15.0,
                              ),
                            ),
                          )
                        : FlatButton(
                            height: 50,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                side: BorderSide(
                                    color: Color.fromRGBO(236, 138, 92, 1))),
                            color: Color.fromRGBO(236, 138, 92, 1),
                            textColor: Colors.white,
                            padding: EdgeInsets.all(8.0),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _login();
                              }
                            },
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
                TextSpan(
                    text: "Sign up here",
                    style: TextStyle(
                        fontSize: 14, color: Color.fromRGBO(236, 138, 92, 1)),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print('to sign up');
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return SignupScreen();
                            },
                          ),
                        );
                      }),
              ]),
            ),
            SizedBox(height: 20),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "By proceeding, you agree to our ",
                    style: TextStyle(fontSize: 12, color: Colors.black54)),
                TextSpan(
                    text: "Terms of Use",
                    style: TextStyle(
                        fontSize: 12, color: Color.fromRGBO(236, 138, 92, 1))),
                TextSpan(
                    text: " and confirm to have read our ",
                    style: TextStyle(fontSize: 12, color: Colors.black54)),
                TextSpan(
                    text: "Privacy Policy",
                    style: TextStyle(
                        fontSize: 12, color: Color.fromRGBO(236, 138, 92, 1))),
              ]),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
