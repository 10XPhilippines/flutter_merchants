import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_merchants/network_utils/api.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Uint8List bytes = Uint8List(0);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool hasConnection = false;
  Map business = {};
  bool defaultBusiness;
  int defaultMerchant;
  String merchant;
  List history = [];
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

  getHistory() async {
    setState(() {
      _isLoading = true;
    });
    if (hasConnection == true) {
      var res =
          await Network().getData('/get_history/' + defaultMerchant.toString());
      var body = json.decode(res.body);
      if (body['success']) {
        print("Debug history");
        print(body);
        setState(() {
          _isLoading = false;
          history = body["history"];
        });
        print(body);
      } else {
        setState(() {
          _isLoading = false;
        });
        final snackBar = SnackBar(
          duration: Duration(minutes: 5),
          content: Container(
              height: 40.0,
              child: Center(
                child: Text(
                  body["message"],
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
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

  getDefaultBusiness() async {
    setState(() {
      _isLoading = true;
    });
    if (hasConnection == true) {
      var res = await Network()
          .getData('/check_default_business/' + userId.toString());
      var body = json.decode(res.body);
      if (body['success']) {
        print("Debug business");
        print(body);
        setState(() {
          _isLoading = false;
          defaultBusiness = true;

          defaultMerchant = body["business"]["id"];
          merchant = body["business"]["business_name"];
          print(defaultMerchant.toString());
        });
        getHistory();
      } else {
        setState(() {
          _isLoading = false;
          defaultBusiness = false;
        });
        final snackBar = SnackBar(
          duration: Duration(minutes: 5),
          content: Container(
              height: 40.0,
              child: Center(
                child: Text(
                  body["message"],
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
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
        getDefaultBusiness();
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
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   leading: IconButton(
      //     icon: Icon(
      //       Icons.keyboard_backspace,
      //     ),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   centerTitle: true,
      //   title: Text(
      //     "History",
      //   ),
      //   elevation: 0.0,
      // ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          shrinkWrap: true,
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
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                      top: 25.0,
                      left: 10.0,
                    ),
                    child: merchant == null
                        ? Text("")
                        : Text(
                            "History of scanned customer in $merchant business.",
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54),
                          ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  history.length != 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: history == null ? 0 : history.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new ListTile(
                              title: Text(
                                history[index]["trace_name"],
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                  '${history[index]["trace_barangay"]}, ${history[index]["trace_municipality"]}, ${history[index]["trace_province"]}'),
                              onTap: () {
                                print(history[index]["id"]);
                                showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                    ),
                                    context: context,
                                    builder: (builder) {
                                      return new Container(
                                        height: 400.0,
                                        color: Colors.transparent,
                                        child: Container(
                                            alignment: Alignment.topLeft,
                                            margin: EdgeInsets.only(
                                              left: 20.0,
                                              top: 20.0,
                                              right: 20.0,
                                            ),
                                            child: ListView(
                                              children: <Widget>[
                                                ListTile(
                                                  title: Text(
                                                    history[index]
                                                        ["trace_name"],
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    history[index]
                                                        ["trace_email"],
                                                  ),
                                                  trailing: IconButton(
                                                    icon: Icon(
                                                      Icons.close,
                                                      size: 18.0,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                ListTile(
                                                  title: Text(
                                                    "Contact Number",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    history[index][
                                                        "trace_contact_number"],
                                                  ),
                                                  trailing: IconButton(
                                                    icon: Icon(
                                                      Icons.content_copy,
                                                      size: 18.0,
                                                    ),
                                                    onPressed: () {
                                                      Clipboard.setData(
                                                          new ClipboardData(
                                                              text: history[
                                                                      index][
                                                                  "trace_contact_number"]));
                                                      Toast.show(
                                                          "Copied to clipboard.",
                                                          context,
                                                          duration: Toast
                                                              .LENGTH_SHORT,
                                                          gravity:
                                                              Toast.BOTTOM);
                                                    },
                                                  ),
                                                ),
                                                Divider(),
                                                ListTile(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          right: 25, left: 18),
                                                  title: Text(
                                                    "Temperature",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  trailing: Text(
                                                    history[index]
                                                        ["temperature"],
                                                  ),
                                                ),
                                                Divider(),
                                                ListTile(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          right: 25, left: 18),
                                                  title: Text(
                                                    "Has sorethroat?",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  trailing: Text(
                                                    history[index][
                                                        "trace_question_sore_throat"],
                                                  ),
                                                ),
                                                Divider(),
                                                ListTile(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          right: 25, left: 18),
                                                  title: Text(
                                                    "Has headache?",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  trailing: Text(
                                                    history[index][
                                                        "trace_question_headache"],
                                                  ),
                                                ),
                                                Divider(),
                                                ListTile(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          right: 25, left: 18),
                                                  title: Text(
                                                    "Has fever?",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  trailing: Text(
                                                    history[index][
                                                        "trace_question_fever"],
                                                  ),
                                                ),
                                                Divider(),
                                                ListTile(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          right: 25, left: 18),
                                                  title: Text(
                                                    "Has cough or colds?",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  trailing: Text(
                                                    history[index][
                                                        "trace_question_cough_cold"],
                                                  ),
                                                ),
                                                Divider(),
                                                ListTile(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          right: 25, left: 18),
                                                  title: Text(
                                                    "Has exposure?",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  trailing: Text(
                                                    history[index][
                                                        "trace_question_exposure"],
                                                  ),
                                                ),
                                                Divider(),
                                                ListTile(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          right: 25, left: 18),
                                                  title: Text(
                                                    "Has travel history?",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  trailing: Text(
                                                    history[index][
                                                        "trace_question_travel_history"],
                                                  ),
                                                ),
                                                Divider(),
                                                ListTile(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          right: 25, left: 18),
                                                  title: Text(
                                                    "Has body pain?",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  trailing: Text(
                                                    history[index][
                                                        "trace_question_body_pain"],
                                                  ),
                                                ),
                                              ],
                                            )),
                                      );
                                    });
                              },
                            );
                          },
                        )
                      : Center(
                          child: Padding(
                            padding: EdgeInsets.all(100),
                            child: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                Image.asset(
                                  'assets/empty.png',
                                  height: 100,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Such an empty!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
