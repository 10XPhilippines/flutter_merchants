import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_merchants/screens/dishes.dart';

class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen>
    with AutomaticKeepAliveClientMixin<SigninScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
        child: ListView(
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
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 30),
            FlatButton(
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(color: Color.fromRGBO(236, 138, 92, 1))),
              color: Colors.white,
              textColor: Color.fromRGBO(236, 138, 92, 1),
              padding: EdgeInsets.only(left: 30, right: 30),
              onPressed: () {},
              child: Text(
                "Continue with Facebook",
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
