import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_merchants/network_utils/api.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitScreen extends StatefulWidget {
  @override
  _VisitScreenState createState() => _VisitScreenState();
}

class _VisitScreenState extends State<VisitScreen> {
  Future<void> _launched;
  Uint8List bytes = Uint8List(0);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _isLoading2 = false;
  bool hasConnection = false;
  Map business = {};
  bool defaultBusiness;
  int defaultMerchant;
  String merchant;
  List history = [];
  List companion = [];
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

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String toTitleCase(String str) {
    return str
        .replaceAllMapped(
            RegExp(
                r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+'),
            (Match m) =>
                "${m[0][0].toUpperCase()}${m[0].substring(1).toLowerCase()}")
        .replaceAll(RegExp(r'(_|-)+'), ' ');
  }

  getProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    data = preferences.getString("user");
    setState(() {
      business = json.decode(data);
      userId = int.parse(business["id"].toString());
    });
    getVisits();
    print(userId.toString());
  }

  getCompanion(String companionId) async {
    debugPrint("Get companion");
    setState(() {
      _isLoading2 = true;
    });
    try {
      var res = await Network().getData('/get_companion_by_id/' + companionId);
      var body = json.decode(res.body);
      if (body['success']) {
        setState(() {
          _isLoading2 = false;
          companion = body["companion"];
        });
        print(companion);
        print(_isLoading2);
      } else {
        setState(() {
          _isLoading2 = false;
        });
        final snackBar = SnackBar(
          duration: Duration(seconds: 2),
          content: Container(
              height: 40.0,
              child: Center(
                child: Text(
                  "Unable to fetch data",
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              )),
          backgroundColor: Colors.redAccent,
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    } catch (e) {
      setState(() {
        _isLoading2 = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (builder) {
        return new Container(
          height: 250.0,
          color: Colors.transparent,
          child: _isLoading2
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
              : Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(
                    left: 20.0,
                    top: 20.0,
                    right: 20.0,
                  ),
                  child: ListView(children: <Widget>[
                    companion.length != 0
                        ? Container(
                            child: Text("List of companions"),
                            margin: EdgeInsets.only(
                              left: 15.0,
                              top: 5.0,
                              bottom: 5.0,
                              right: 15.0,
                            ),
                          )
                        : Text(""),
                    companion.length != 0
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: companion == null ? 0 : companion.length,
                            itemBuilder: (BuildContext context, int index) {
                              return new ListTile(
                                title: Text(
                                  companion[index]["companion_first_name"] +
                                      ' ' +
                                      companion[index]["companion_last_name"] +
                                      ', ' +
                                      companion[index]
                                          ["companion_temperature"] +
                                      "°",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Text(
                                    '${companion[index]["companion_street"]}, ${companion[index]["companion_barangay"]}, ${companion[index]["companion_municipality"]}, ${companion[index]["companion_province"]}'),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.call,
                                    color: Colors.redAccent,
                                    size: 20.0,
                                  ),
                                  onPressed: () => setState(() {
                                    _launched = _makePhoneCall(
                                        'tel:$companion[index]["companion_contact_number"]');
                                    print(companion[index]
                                        ["companion_contact_number"]);
                                  }),
                                ),
                              );
                            })
                        : Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
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
                                    "No companion added!",
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
                  ]),
                ),
        );
      },
    );
  }

  getVisits() async {
    debugPrint("Get visits");
    setState(() {
      _isLoading = true;
    });
    try {
      var res = await Network()
          .getData('/visited_establishments/' + userId.toString());
      var body = json.decode(res.body);
      if (body['success']) {
        print("Debug visits");
        print(body);
        setState(() {
          _isLoading = false;
          history = body["visits"];
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
    } catch (e) {
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
    setState(() {
      _isLoading = false;
    });
  }

  _checkIfConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        setState(() {
          hasConnection = true;
        });
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
          "Visits",
        ),
        elevation: 0.0,
      ),
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
                      left: 15.0,
                      right: 15.0,
                    ),
                    child: Text(
                      "List of your visited establishments. Tap to view companion.",
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  history.length != 0
                      ? ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: history == null ? 0 : history.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new ListTile(
                              title: Text(
                                history[index]["business_name"],
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                '${toTitleCase(history[index]["business_address"])}\nVisited on ${history[index]["trace_date_time_entry"]}\n',
                              ),
                              onTap: () {
                                print(history[index]["tracers_companion_code"]);
                                getCompanion(
                                    history[index]["tracers_companion_code"]);
                              },
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.qr_code,
                                  size: 20.0,
                                ),
                                onPressed: () {
                                  print("QR");
                                  showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                    ),
                                    context: context,
                                    builder: (builder) {
                                      return new Container(
                                        height: 250.0,
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
                                              Center(
                                                child: Text(
                                                    "Scan to view dynamic QR"),
                                              ),
                                              Center(
                                                child: QrImage(
                                                  data: history[index]
                                                      ["qr_data"],
                                                  version: QrVersions.auto,
                                                  size: 200.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                tooltip: "Edit",
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Padding(
                            padding: EdgeInsets.all(78),
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
