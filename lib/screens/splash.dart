import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_merchants/screens/walkthrough.dart';
import 'package:flutter_merchants/util/const.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimeout() {
    return Timer(Duration(seconds: 5), changeScreen);
  }

  changeScreen() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Walkthrough();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        margin: EdgeInsets.only(left: 40.0, right: 40.0),
        child: Center(
          child: Column(
            children: <Widget>[
              // Icon(
              //   Icons.fastfood,
              //   size: 150.0,
              //   color: Theme.of(context).accentColor,
              // ),
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/logo.png',
                    width: 160,
                  ),
                ),
              ),

              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Text("10xphilippines.com",
              //       style: TextStyle(
              //           fontSize: 20, color: Color.fromRGBO(236, 138, 92, 1))),
              // )

              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(
                  top: 15.0,
                  bottom: 20.0
                ),
                child: Text(
                  "10xphilippines.com",
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(236, 138, 92, 1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
