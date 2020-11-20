import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_merchants/screens/screen_signup.dart';

class CheckOutScreen extends StatefulWidget {
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen>
    with AutomaticKeepAliveClientMixin<CheckOutScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
