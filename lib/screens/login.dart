import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_merchants/screens/main_screen.dart';
import 'package:flutter_merchants/screens/forgot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_merchants/network_utils/api.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameControl = new TextEditingController();
  final TextEditingController _passwordControl = new TextEditingController();
  var email;
  var password;
  Map profile = {};
  String datas;
  String dataOtp;
  int userId;
  int isVerified;
  bool _isLoading = false;
  bool _isButtonDisabled = false;
  BuildContext _context;
  String responseName = "Enter your name";
  String responsePassword = "Enter your password";
  String message;

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
              resendOtp();
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
                title: Text("Failed"),
                content: Text(message),
                actions: <Widget>[
                  new FlatButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              );
            });
        print(body);
      }

      print("Debug login");
      print(body);

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

  resendOtp() async {
    var input = {'id': userId};
    print(input);

    var res = await Network().authData(input, '/resend');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      dataOtp = preferences.getString("user");
    }
    print('Debug OTP resend');
    print(userId);
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
              "Log in to your account",
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
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
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
                  hintText: "Enter your email",
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black54,
                  ),
                  // prefixIcon: Icon(
                  //   Icons.perm_identity,
                  //   color: Colors.black,
                  // ),
                ),
                maxLines: 1,
                controller: _usernameControl,
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
                  hintText: "Enter your password",
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

          SizedBox(height: 10.0),

          Container(
            alignment: Alignment.centerRight,
            child: FlatButton(
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).accentColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      resendOtp();
                      return ForgotScreen();
                    },
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 30.0),

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
                      'Login'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
              onPressed: _isButtonDisabled ? null : () => _login(),
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

          // Center(
          //   child: Container(
          //     width: MediaQuery.of(context).size.width/2,
          //     child: Row(
          //       children: <Widget>[
          //         RawMaterialButton(
          //           onPressed: (){},
          //           fillColor: Colors.blue[800],
          //           shape: CircleBorder(),
          //           elevation: 4.0,
          //           child: Padding(
          //             padding: EdgeInsets.all(15),
          //             child: Icon(
          //               FontAwesomeIcons.facebookF,
          //               color: Colors.white,
          //               //size: 24.0,
          //             ),
          //           ),
          //         ),

          //         RawMaterialButton(
          //           onPressed: (){},
          //           fillColor: Colors.white,
          //           shape: CircleBorder(),
          //           elevation: 4.0,
          //           child: Padding(
          //             padding: EdgeInsets.all(15),
          //             child: Icon(
          //               FontAwesomeIcons.google,
          //               color: Colors.blue[800],
          //               //size: 24.0,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
