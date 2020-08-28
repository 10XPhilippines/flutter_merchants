import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_merchants/network_utils/api.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DefaultBusinessScreen extends StatefulWidget {
  @override
  _DefaultBusinessScreenState createState() => _DefaultBusinessScreenState();
}

class _DefaultBusinessScreenState extends State<DefaultBusinessScreen> {
  Uint8List bytes = Uint8List(0);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool hasConnection = false;
  Map business = {};
  List<dynamic> list = [];
  String data;
  String picked;
  int userId;
  List businessId = [];
  List<String> businessList = [];
  String message;

  @override
  void initState() {
    getProfile();
    _checkIfConnected();
    super.initState();
  }

  getProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    data = preferences.getString("user");
    setState(() {
      business = json.decode(data);
      userId = int.parse(business["id"].toString());
    });
  }

  getBusiness() async {
    setState(() {
      _isLoading = true;
    });
    var input = {'id': userId};
    print(input);

    if (hasConnection == true) {
      var res = await Network().authData(input, '/fetch_business');
      var body = json.decode(res.body);
      if (body['success']) {
        print("Debug business");
        print(body);
        setState(() {
          _isLoading = false;
          list = body["business"];
          for (var item in list) {
            businessList.add(item["business_name"]);
            businessId.add(item["business_name"].toString());
          }
        });
      } else {
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
        _scaffoldKey.currentState.showSnackBar(snackBar);
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
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  save(String business) async {
    setState(() {
      _isLoading = true;
      picked = business;
    });
    var input = {'user_id': userId, 'business_name': business};
    print(input);

    if (hasConnection == true) {
      var res = await Network().authData(input, '/save_default_business');
      var body = json.decode(res.body);
      if (body['success']) {
        print("Debug business");
        print(body);
        setState(() {
          message = body["message"];
          _isLoading = false;
        });
        final snackBar = SnackBar(
          duration: Duration(seconds: 5),
          content: Container(
              height: 40.0,
              child: Center(
                child: Text(
                  message,
                  style: TextStyle(fontSize: 16.0),
                ),
              )),
          backgroundColor: Colors.greenAccent,
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
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
        getBusiness();
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
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
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
          "Default Business",
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          shrinkWrap: true,
          children: _isLoading
              ? <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                      top: 25.0,
                      left: 10.0,
                    ),
                    child: Text(
                      "Choose default business to be use in contact tracing.",
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54),
                    ),
                  ),
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
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                      top: 25.0,
                      left: 10.0,
                    ),
                    child: Text(
                      "Choose default business to be use in contact tracing.",
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RadioButtonGroup(
                    labels: businessList,
                    picked: picked,
                    onSelected: (String business) => save(business),
                  ),
                ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //
      //   },
      //   label: Text('Save'),
      //   icon: Icon(Icons.check_circle),
      //   backgroundColor: Colors.pink,
      // ),
    );
  }
}
