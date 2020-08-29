import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
//import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_merchants/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_select/smart_select.dart';
import 'package:flutter_merchants/screens/main_screen.dart';
import 'package:flutter_merchants/screens/default_business.dart';
import 'package:twitter_qr_scanner/twitter_qr_scanner.dart';
import 'package:twitter_qr_scanner/QrScannerOverlayShape.dart';

var qrText;
bool hasQrValue = false;
String userIdFetch = "";
String userId = "";
String dateEntry = "";
String dateExit = "";
String soreThroat = "-";
String headAche = "-";
String fever = "-";
String cough = "-";
String exposure = "-";
String travelHistory = "-";
String bodyPain = "-";

bool _isLoading = false;
bool hasConnection = false;

class Questions extends StatefulWidget {
  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  final TextEditingController _phoneControl = new TextEditingController();
  final TextEditingController _nameControl = new TextEditingController();
  final TextEditingController _emailControl = new TextEditingController();
  GlobalKey qrKey = GlobalKey();
  QRViewController controller;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map profile = {};
  Map fetchUser = {};
  Map business = {};
  Map user = {};
  bool defaultBusiness;
  int defaultMerchant;
  String data;
  String barcode = "";
  String businessName = "No scanned code yet";
  String businessId = "";

  var name;
  var email;
  var phoneNumber;
  var street;
  var gender;
  var barangay;
  var municipality;
  var province;
  var facebook;
  var temperature;

  List<SmartSelectOption<String>> options = [
    SmartSelectOption<String>(value: 'Yes', title: 'Yes'),
    SmartSelectOption<String>(value: 'No', title: 'No'),
  ];

  DateTime now = DateTime.now();

  fetchUserData() async {
    if (hasQrValue == true) {
      setState(() {
        _isLoading = true;
      });
      if (hasConnection == true) {
        var res = await Network().getData('/user/' + userIdFetch.toString());
        var body = json.decode(res.body);
        if (body['success']) {
          print("Debug user");
          print(body);
          setState(() {
            _isLoading = false;
            fetchUser = body["user"];
            name = fetchUser["name"];
            gender = fetchUser["sex"];
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {}
    } else {
      print(hasQrValue);
    }
  }

  _checkIfScanned() {
    print("QR is empty");
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Scan"),
            content: Text("Scan a customer code first."),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    // _scan();
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Scan'),
                  onPressed: () {
                    // _scan();
                    Navigator.pop(context);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => QRExample()));
                  })
            ],
          );
        });
  }

  getDefaultBusiness() async {
    setState(() {
      _isLoading = true;
      barcode = qrText;
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

          //Populate the text fields
          defaultMerchant = body["business"]["id"];
          print(defaultMerchant.toString());
        });
      } else {
        setState(() {
          _isLoading = false;
          defaultBusiness = false;
        });
        final snackBar = SnackBar(
          duration: Duration(seconds: 5),
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
                'Network is unreachable',
                style: TextStyle(fontSize: 16.0),
              ),
            )),
        backgroundColor: Colors.redAccent,
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    getProfile();
    _checkIfConnected();
    setState(() {
      barcode = "";
    });
    fetchUserData();
    super.initState();
  }

  getProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    data = preferences.getString("user");
    setState(() {
      profile = json.decode(data);
      userId = profile["id"].toString();
    });
  }

  submitSurvey() async {
    var data = {
      'user_id': userIdFetch,
      'business_id': defaultMerchant,
      'trace_name': name,
      'trace_gender': gender,
      'trace_contact_number': phoneNumber,
    };

    print(data);
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
          "Wait Lang!",
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.camera),
            onPressed: () {
              // _scan();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => QRExample()));
            },
            tooltip: "Save",
          ),
        ],
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
                    margin: EdgeInsets.only(top: 25.0, left: 10.0),
                    child: Text(
                      "Scan a customer code.",
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54),
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
                        readOnly: true,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle:
                              TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
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
                          hintText: "Enter customer name",
                          // prefixIcon: Icon(
                          //   Icons.perm_identity,
                          //   color: Colors.black,
                          // ),
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
                        controller: TextEditingController(
                                text: fetchUser["name"]) ??
                            TextEditingController(text: "No data available"),
                        onChanged: (value) {
                          name = value;
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
                        enabled: true,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          labelStyle:
                              TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
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
                          hintText: "Enter customer email",
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
                        controller: TextEditingController(
                                text: fetchUser["email"]) ??
                            TextEditingController(text: "No data available"),
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
                        enabled: true,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          labelStyle:
                              TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
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
                          hintText: "Enter customer phone number",
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
                        controller: TextEditingController(
                                text: fetchUser["phone"]) ??
                            TextEditingController(text: "No data available"),
                        onChanged: (value) {
                          phoneNumber = value;
                        },
                      ),
                    ),
                  ),
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
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelText: "Municipality",
                          labelStyle:
                              TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
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
                          hintText: "Enter customer municipality",
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
                        controller:
                            TextEditingController(text: fetchUser["city"]),
                        onChanged: (value) {
                          municipality = value;
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
                        decoration: InputDecoration(
                          labelText: "Province",
                          labelStyle:
                              TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
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
                          hintText: "Enter customer province",
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
                        controller:
                            TextEditingController(text: fetchUser["province"]),
                        onChanged: (value) {
                          province = value;
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
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Temperature",
                          labelStyle:
                              TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
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
                          hintText: "Enter customer temperature",
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
                        onChanged: (value) {
                          temperature = value;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                      top: 25.0,
                      left: 10.0,
                    ),
                    child: Text(
                      "Answers",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ListTile(
                    title: Text(
                      "1. Customer has sore throat?",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    trailing: Text(
                      soreThroat ?? 'No data',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  ListTile(
                    title: Text(
                      "2. Customer has headache?",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    trailing: Text(
                      headAche ?? 'No data',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  ListTile(
                    title: Text(
                      "3. Customer has fever?",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    trailing: Text(
                      fever ?? 'No data',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  ListTile(
                    title: Text(
                      "4. Customer has travel history?",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    trailing: Text(
                      travelHistory ?? 'No data',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  ListTile(
                    title: Text(
                      "5. Customer has exposure to patient?",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    trailing: Text(
                      exposure ?? 'No data',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  ListTile(
                    title: Text(
                      "6. Customer has cough or colds?",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    trailing: Text(
                      cough ?? 'No data',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  ListTile(
                    title: Text(
                      "7. Customer has body pain?",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    trailing: Text(
                      bodyPain ?? 'No data',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 80.0),
                ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // print("Global qrText = " + qrText);
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirm"),
                  content: Text("Do you want to submit survey now?"),
                  actions: <Widget>[
                    new FlatButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    new FlatButton(
                        child: const Text('Submit'),
                        onPressed: () {
                          if (barcode?.isEmpty ?? true) {
                            Navigator.pop(context);
                            _checkIfScanned();
                          } else {
                            Navigator.pop(context);
                            submitSurvey();
                          }
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

class QRExample extends StatefulWidget {
  QRExample({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _QRExampleState createState() => _QRExampleState();
}

class _QRExampleState extends State<QRExample> {
  GlobalKey qrKey = GlobalKey();
  QRViewController controller;
  Map profile = {};
  String data;

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: QRView(
          key: qrKey,
          overlay: QrScannerOverlayShape(
              borderRadius: 16,
              borderColor: Colors.white,
              borderLength: 120,
              borderWidth: 10,
              cutOutSize: 250),
          onQRViewCreated: _onQRViewCreate,
          data: profile["user_barcode_name"],
        ));
  }

  getProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    data = preferences.getString("user");
    setState(() {
      profile = json.decode(data);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  setFields() async {
    String surveys = qrText
        .toString()
        .replaceAll(new RegExp(r'\['), '')
        .replaceAll(new RegExp(r'\]'), '');
    print(surveys);
    List<String> list = surveys.split(", ");

    setState(() {
      userIdFetch = list[0];
      dateEntry = list[1];
      soreThroat = list[2];
      headAche = list[3];
      fever = list[4];
      travelHistory = list[5];
      exposure = list[6];
      cough = list[7];
      bodyPain = list[8];
    });
  }

  void _onQRViewCreate(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
        hasQrValue = true;
        setFields();
        dispose();
        Route route = MaterialPageRoute(builder: (context) => Questions());
        Navigator.pushReplacement(context, route);
      });
    });
  }
}
