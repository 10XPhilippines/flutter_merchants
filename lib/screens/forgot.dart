import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
// import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_merchants/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_select/smart_select.dart';
import 'package:flutter_merchants/screens/main_screen.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  var email;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _email = new TextEditingController();

  String validateEmail = "Enter your email";

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
                'Network is unreachable',
                style: TextStyle(fontSize: 16.0),
              ),
            )),
        backgroundColor: Colors.redAccent,
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  void reset() async {
    var data = {'email': email};
    print(data);

    var res = await Network().authData(data, '/reset');
    var body = json.decode(res.body);
    if (body['success']) {
      print(body);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Failed"),
              content: Text(validateEmail),
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
        validateEmail = body["message"]["email"]
            .toString()
            .replaceAll(new RegExp(r'\['), '')
            .replaceAll(new RegExp(r'\]'), '');
        if (validateEmail == "null") {
          validateEmail = "Enter your name";
        }
      });
    }
  }

  @override
  void initState() {
    _checkIfConnected();
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
          "Password Reset",
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
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
                  enabled: true,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email Address",
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
                    hintText: validateEmail ?? "Enter your email",
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
                  controller: _email,
                  onChanged: (value) {
                    email = value;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirm"),
                  content: Text("Do you want to submit email now?"),
                  actions: <Widget>[
                    new FlatButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    new FlatButton(
                        child: const Text('Submit'),
                        onPressed: () {
                          reset();
                          Navigator.pop(context);
                        })
                  ],
                );
              });
        },
        label: Text('Submit'),
        icon: Icon(Icons.check_circle),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
