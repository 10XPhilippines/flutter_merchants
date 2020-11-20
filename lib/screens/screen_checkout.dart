import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_merchants/network_utils/api.dart';
import 'package:flutter_merchants/screens/screen_generate.dart';
import 'package:flutter_merchants/screens/screen_signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'main_screen.dart';

class CheckOutScreen extends StatefulWidget {
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen>
    with AutomaticKeepAliveClientMixin<CheckOutScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  Map profile = {};
  String data;
  String userId;

  @override
  void initState() {
    super.initState();
    getProfile();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
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

  getProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    data = preferences.getString("user");
    setState(() {
      profile = json.decode(data);
      userId = profile["id"].toString();
    });
    print("Checkout: $data");
  }

  Future checkout() async {
    showLoading();
    var res = await Network().getData('/checkout_app/' + userId.toString());
    var body = json.decode(res.body);

    if (body["success"] == true) {
      Navigator.pop(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("checkout", "true");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MainScreen()));
    } else {
      print(body);
      Navigator.pop(context);
      Toast.show("Unable to check out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
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
                  "Don't forget",
                  style: TextStyle(
                      color: Color.fromRGBO(236, 138, 92, 1),
                      fontSize: 40,
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: 50),
              Center(
                child: Icon(Icons.alarm,
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
                  onPressed: () {
                    checkout();
                  },
                  child: Text(
                    "Check Out",
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
