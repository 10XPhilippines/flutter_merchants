import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_merchants/widgets/badge.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_merchants/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_select/smart_select.dart';
import 'package:flutter_merchants/screens/main_screen.dart';

class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  Uint8List bytes = Uint8List(0);
  Map profile = {};
  String data;
  String userId;
  String dateEntry;
  String dateExit;
  String soreThroat;
  String headAche;
  String fever;
  String cough;
  String exposure;
  String travelHistory;
  String bodyPain;
  int indicator = 0;
  bool isDone = false;
  var rawJson = ['Q1', 'Q2', 'Q3', 'Q4', 'Q5', 'Q6', 'Q7'];

  List<SmartSelectOption<String>> options = [
    SmartSelectOption<String>(value: 'Yes', title: 'Yes'),
    SmartSelectOption<String>(value: 'No', title: 'No'),
  ];

  DateTime now = DateTime.now();

  getProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    data = preferences.getString("user");
    setState(() {
      profile = json.decode(data);
      userId = profile["id"].toString();
      dateEntry = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
      rawJson.insert(0, userId);
      rawJson.insert(1, dateEntry);
    });
    print(data);
    print(rawJson);
    _generateBarCode(rawJson.toString());
  }

  Future _generateBarCode(String inputCode) async {
    Uint8List result = await scanner.generateBarCode(inputCode);
    this.setState(() => this.bytes = result);
    if (indicator >= 7) {
      setState(() {
        isDone = true;
      });
    }
    print("isDone = " + isDone.toString());
  }

  @override
  void initState() {
    getProfile();
    super.initState();
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save_alt),
            onPressed: () {},
            tooltip: "Save",
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(
              height: 190,
              child: isDone
                  ? Image.memory(bytes)
                  : Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: ExactAssetImage('assets/tick.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
            ),
            SizedBox(
              height: 20,
              child: isDone
                  ? Text(
                      "Merchant will scan this code",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
                    )
                  : Text(
                      "Please complete the survey",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
                    ),
            ),
            // SizedBox(
            //   height: 20,
            // ),
            // StepsIndicator(
            //   selectedStep: indicator,
            //   nbSteps: 7,
            //   selectedStepColorOut: Colors.blue,
            //   selectedStepColorIn: Colors.blue,
            //   doneStepColor: Colors.blue,
            //   unselectedStepColor: Colors.red,
            //   doneLineColor: Colors.blue,
            //   undoneLineColor: Colors.red,
            //   isHorizontal: true,
            //   lineLength: 40,
            //   lineThickness: 1,
            //   doneStepSize: 10,
            //   unselectedStepSize: 10,
            //   selectedStepSize: 10,
            //   selectedStepBorderSize: 1,
            // ),
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
                onChange: (val) => {
                      setState(() {
                        soreThroat = val;
                        if (rawJson[2] == "Q1") {
                          indicator += 1;
                        }
                        if (rawJson.asMap().containsKey(2) == false) {
                          rawJson.insert(2, val);
                        } else {
                          rawJson.removeAt(2);
                          rawJson.insert(2, val);
                        }
                        print(rawJson);
                        print(rawJson.asMap().containsKey(2));
                        _generateBarCode(rawJson.toString());
                      })
                    }),
            SizedBox(height: 10.0),
            SmartSelect<String>.single(
                title: 'Do you have headache?',
                value: headAche,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => {
                      setState(() {
                        if (rawJson[3] == "Q2") {
                          indicator += 1;
                        }
                        headAche = val;
                        if (rawJson.asMap().containsKey(3) == false) {
                          rawJson.insert(3, val);
                        } else {
                          rawJson.removeAt(3);
                          rawJson.insert(3, val);
                        }
                        print(rawJson);
                        print(rawJson.asMap().containsKey(3));
                        _generateBarCode(rawJson.toString());
                      })
                    }),
            SizedBox(height: 10.0),
            SmartSelect<String>.single(
                title: 'Do you have fever?',
                value: fever,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => {
                      setState(() {
                        if (rawJson[4] == "Q3") {
                          indicator += 1;
                        }
                        fever = val;
                        if (rawJson.asMap().containsKey(4) == false) {
                          rawJson.insert(4, val);
                        } else {
                          rawJson.removeAt(4);
                          rawJson.insert(4, val);
                        }
                        print(rawJson);
                        print(rawJson.asMap().containsKey(4));
                        _generateBarCode(rawJson.toString());
                      })
                    }),
            SizedBox(height: 10.0),
            SmartSelect<String>.single(
                title: 'Do you have travel history?',
                value: travelHistory,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => {
                      setState(() {
                        if (rawJson[5] == "Q4") {
                          indicator += 1;
                        }
                        travelHistory = val;
                        if (rawJson.asMap().containsKey(5) == false) {
                          rawJson.insert(5, val);
                        } else {
                          rawJson.removeAt(5);
                          rawJson.insert(5, val);
                        }
                        print(rawJson);
                        print(rawJson.asMap().containsKey(5));
                        _generateBarCode(rawJson.toString());
                      })
                    }),
            SizedBox(height: 10.0),
            SmartSelect<String>.single(
                title: 'Do you have exposure?',
                value: exposure,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => {
                      setState(() {
                        if (rawJson[6] == "Q5") {
                          indicator += 1;
                        }
                        exposure = val;
                        if (rawJson.asMap().containsKey(6) == false) {
                          rawJson.insert(6, val);
                        } else {
                          rawJson.removeAt(6);
                          rawJson.insert(6, val);
                        }
                        print(rawJson);
                        print(rawJson.asMap().containsKey(6));
                        _generateBarCode(rawJson.toString());
                      })
                    }),
            SizedBox(height: 10.0),
            SmartSelect<String>.single(
                title: 'Do you have cough or colds?',
                value: cough,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => {
                      setState(() {
                        if (rawJson[7] == "Q6") {
                          indicator += 1;
                        }
                        cough = val;
                        if (rawJson.asMap().containsKey(7) == false) {
                          rawJson.insert(7, val);
                        } else {
                          rawJson.removeAt(7);
                          rawJson.insert(7, val);
                        }
                        print(rawJson);
                        print(rawJson.asMap().containsKey(7));
                        _generateBarCode(rawJson.toString());
                      })
                    }),
            SizedBox(height: 10.0),
            SmartSelect<String>.single(
                title: 'Do you have body pain?',
                value: bodyPain,
                options: options,
                modalType: SmartSelectModalType.bottomSheet,
                choiceType: SmartSelectChoiceType.radios,
                onChange: (val) => {
                      setState(() {
                        if (rawJson[8] == "Q7") {
                          indicator += 1;
                        }
                        bodyPain = val;
                        if (rawJson.asMap().containsKey(8) == false) {
                          rawJson.insert(8, val);
                        } else {
                          rawJson.removeAt(8);
                          rawJson.insert(8, val);
                        }
                        print(rawJson);
                        print(rawJson.asMap().containsKey(8));
                        _generateBarCode(rawJson.toString());
                      })
                    }),
            SizedBox(height: 40.0),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     print(rawJson);
      //     print("indicator = " + indicator.toString());
      //   },
      //   label: Text('Save'),
      //   icon: Icon(Icons.check_circle),
      //   backgroundColor: Colors.pink,
      // ),
    );
  }
}
