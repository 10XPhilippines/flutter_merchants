import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_merchants/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_select/smart_select.dart';
import 'package:flutter_merchants/screens/main_screen.dart';

class Questions extends StatefulWidget {
  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  final TextEditingController _phoneControl = new TextEditingController();
  final TextEditingController _nameControl = new TextEditingController();
  final TextEditingController _emailControl = new TextEditingController();
  Map profile = {};
  Map business = {};
  Map user = {};
  String data;
  String barcode = "";
  bool hasBusiness = false;
  String businessName = "No scanned code yet";
  String businessId = "";
  String userId = "";
  String dateEntry = "";
  String dateExit = "";
  String soreThroat = "";
  String headAche = "";
  String fever = "";
  String cough = "";
  String exposure = "";
  String travelHistory = "";
  String bodyPain = "";
  var name;
  var email;
  var phoneNumber;
  var street;
  var barangay;
  var municipality;
  var province;
  var facebook;

  List<SmartSelectOption<String>> options = [
    SmartSelectOption<String>(value: 'Yes', title: 'Yes'),
    SmartSelectOption<String>(value: 'No', title: 'No'),
  ];

  DateTime now = DateTime.now();

  _checkIfScanned() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Scan"),
            content: Text("Scan a business QR Code first."),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Scan'),
                  onPressed: () {
                    _scan();
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  _checkIfConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Network"),
              content: Text("You are not connected to the internet."),
              actions: <Widget>[
                new FlatButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            );
          });
    }
  }

  @override
  void initState() {
    _checkIfConnected();
    getProfile();
    _scan();
    super.initState();
  }

  getProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    data = preferences.getString("user");
    setState(() {
      profile = json.decode(data);
    });
  }

  Future _scan() async {
    String barcode = await scanner.scan();
    setState(() => this.barcode = barcode);
    if (hasBusiness == false) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Unavailable"),
              content: Text("No business name is linked to that QR code."),
              actions: <Widget>[
                new FlatButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                new FlatButton(
                    child: const Text('Try again'),
                    onPressed: () {
                      Navigator.pop(context);
                      _scan();
                    })
              ],
            );
          });
    }
    print(barcode);
    _getBusiness();
  }

  _getBusiness() async {
    String url = '/business/' + barcode + '/' + profile["id"].toString();
    print("GET: " + url);
    var res = await Network().getData(url);
    var body = json.decode(res.body);
    if (body['success']) {
      setState(() {
        business = body;
        businessName = business["business"]["business_name"];
        hasBusiness = true;
        dateEntry = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
        businessId = business["business"]["id"].toString();
        userId = business["user"]["id"].toString();
        name = profile["name"];
        email = profile["email"];
        phoneNumber = profile["phone"];
      });
    } else {
      setState(() {
        hasBusiness = false;
      });
    }
    print(businessId);
    print(dateEntry);
    print(userId);
    print(hasBusiness);
    print(business);
  }

  void _postTrace() async {
    _checkIfConnected();
    var traceData = {
      'user_id': userId,
      'business_id': businessId,
      'trace_name': name,
      'trace_contact_number': phoneNumber,
      'trace_street': street,
      'trace_barangay': barangay,
      'trace_municipality': municipality,
      'trace_province': province,
      'trace_facebook_link': facebook,
      'trace_email': email,
      'trace_date_time_entry': dateEntry,
      'trace_question_sore_throat': soreThroat,
      'trace_question_headache': headAche,
      'trace_question_fever': fever,
      'trace_question_travel_history': travelHistory,
      'trace_question_exposure': exposure,
      'trace_question_cough_cold': cough,
      'trace_question_body_pain': bodyPain,
    };
    print(traceData);

    var response = await Network().authData(traceData, '/tracer');
    var body = json.decode(response.body);
    if (body['success']) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Thanks"),
              content:
                  Text("Survey submitted. Thank you for your cooperation!"),
              actions: <Widget>[
                new FlatButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return MainScreen();
                          },
                        ),
                      );
                    }),
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Failed"),
              content: Text("Please correct the following error."),
              actions: <Widget>[
                new FlatButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            );
          });
      print(body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Contact Tracing",
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 25.0, left: 10.0),
              child: Text(
                businessName,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).accentColor,
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
                    labelText: "Name",
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
                    hintText: "Enter your name",
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
                  controller: TextEditingController(text: profile["name"]),
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
                  controller: TextEditingController(text: profile["email"]),
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
                    hintText: "Enter your phone number",
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
                  controller: TextEditingController(text: profile["phone"]),
                  onChanged: (value) {
                    phoneNumber = value;
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
                    labelText: "Street",
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
                    hintText: "Enter your street",
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
                    street = value;
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
                    labelText: "Barangay",
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
                    hintText: "Enter your barangay",
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
                    barangay = value;
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
                    labelText: "Municipality",
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
                    hintText: "Enter your municipality",
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
                    hintText: "Enter your province",
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
                  decoration: InputDecoration(
                    labelText: "Facebook (Optional)",
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
                    hintText: "Enter your facebook link",
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
                    facebook = value;
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
                "Required Questions",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),

            SizedBox(height: 10.0),

            SmartSelect<String>.single(
                title: 'Do you have sore throat?',
                value: soreThroat,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => setState(() => soreThroat = val)),

            SizedBox(height: 10.0),

            SmartSelect<String>.single(
                title: 'Do you have headache?',
                value: headAche,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => setState(() => headAche = val)),

            SizedBox(height: 10.0),

            SmartSelect<String>.single(
                title: 'Do you have fever?',
                value: fever,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => setState(() => fever = val)),

            SizedBox(height: 10.0),

            SmartSelect<String>.single(
                title: 'Do you have travel history?',
                value: travelHistory,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => setState(() => travelHistory = val)),

            SizedBox(height: 10.0),

            SmartSelect<String>.single(
                title: 'Do you have exposure?',
                value: exposure,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => setState(() => exposure = val)),

            SizedBox(height: 10.0),

            SmartSelect<String>.single(
                title: 'Do you have cough or colds?',
                value: cough,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => setState(() => cough = val)),

            SizedBox(height: 10.0),

            SmartSelect<String>.single(
                title: 'Do you have body pain?',
                value: bodyPain,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => setState(() => bodyPain = val)),

            // Container(
            //   alignment: Alignment.centerRight,
            //   child: FlatButton(
            //     child: Text(
            //       "Submit answers",
            //       style: TextStyle(
            //         fontSize: 14.0,
            //         fontWeight: FontWeight.w500,
            //         color: Theme.of(context).accentColor,
            //       ),
            //     ),
            //     onPressed: () {},
            //   ),
            // ),

            SizedBox(height: 80.0),
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
                          if (barcode.isEmpty) {
                            Navigator.pop(context);
                            _checkIfScanned();
                          } else {
                            Navigator.pop(context);
                            _postTrace();
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
