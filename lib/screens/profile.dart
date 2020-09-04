import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_merchants/providers/app_provider.dart';
import 'package:flutter_merchants/screens/splash.dart';
import 'package:flutter_merchants/screens/login.dart';
import 'package:flutter_merchants/screens/otp.dart';
import 'package:flutter_merchants/screens/change_email.dart';
import 'package:flutter_merchants/screens/default_business.dart';
import 'package:flutter_merchants/screens/history.dart';
import 'package:flutter_merchants/util/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_merchants/network_utils/api.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map profile = {};
  String data = "";
  int userId = 0;
  String isVerified = "0";
  bool hasConnection = false;
  String path = "";
  BuildContext _context;
  bool _isLoading = false;
  String userType;
  String image;

  getProfile() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    data = preferences.getString("user");
    setState(() {
      profile = json.decode(data);
      userType = profile["user_type"];
      isVerified = profile["is_verified"].toString();
      userId = int.parse(profile["id"].toString());
      path = Network().qrCode() + "/code/" + profile["user_barcode_path"];
      image = Network().qrCode() + profile["image"];
      print(image);
      _isLoading = false;
    });
  }

  resendOtp() async {
    setState(() {
      _isLoading = true;
    });
    final input = {'id': userId};
    print(input);
    _checkIfConnected();

    if (hasConnection == true) {
      final res = await Network().authData(input, '/resend');
      final body = json.decode(res.body);
      if (body['success']) {
        print('Debug OTP resend');
        print(userId);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return OtpScreen();
            },
          ),
        );
        setState(() {
          _isLoading = false;
        });
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
      Scaffold.of(_context).hideCurrentSnackBar();
      Scaffold.of(_context).showSnackBar(snackBar);
    }
  }

  void logout() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final res = await Network().getData('/logout');
      final body = json.decode(res.body);
      if (body['success']) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.remove('user');
        localStorage.remove('token');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return SplashScreen();
            },
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e.toString());
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
      Scaffold.of(_context).hideCurrentSnackBar();
      Scaffold.of(_context).showSnackBar(snackBar);
      setState(() {
        _isLoading = false;
      });
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
        getProfile();
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
      Scaffold.of(_context).hideCurrentSnackBar();
      Scaffold.of(_context).showSnackBar(snackBar);
    }
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                  labelText: 'Name',
                  hintText: "Enter name",
                ),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  @override
  void initState() {
    print("Initstate");
    getProfile();
    _checkIfConnected();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: new CircleAvatar(
                          backgroundImage: NetworkImage(
                            image ??
                                "https://img.icons8.com/fluent/48/000000/user-male-circle.png",
                          ),
                          radius: 50.0,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  profile["name"] ?? "No data available",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                isVerified == "1"
                                    ? Icon(
                                        Icons.verified_user,
                                        color: Colors.green,
                                      )
                                    : Icon(Icons.verified_user,
                                        color: Colors.red),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  profile["email"] ?? "No data available",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: _isLoading
                                  ? <Widget>[
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
                                      isVerified == "0"
                                          ? InkWell(
                                              onTap: () {
                                                resendOtp();
                                              },
                                              child: Text(
                                                "Tap to verify account",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                print("profile test");
                                              },
                                              child: Text(
                                                "Tap to edit profile",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.blue,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                    ],
                            ),
                          ],
                        ),
                        flex: 3,
                      ),
                    ],
                  ),
                  // Divider(),
                  Container(height: 15.0),
                  Padding(
                    padding: EdgeInsets.all(0.0),
                    child: ListTile(
                      title: Text(
                        "Account Information".toUpperCase(),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // trailing: IconButton(
                      //   icon: Icon(
                      //     Icons.mode_edit,
                      //     size: 20.0,
                      //   ),
                      //   onPressed: () {
                      //     _showDialog();
                      //   },
                      //   tooltip: "Edit",
                      // ),
                    ),
                  ),

                  ListTile(
                    title: Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      profile["name"] ?? "No data available",
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      profile["email"] ?? "No data available",
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Phone",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      profile["phone"] ?? "No data available",
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Type",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      toBeginningOfSentenceCase(userType) ??
                          "No data available",
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Address",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      profile["province"] ?? "No data available",
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Gender",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      profile["sex"] ?? "No data available",
                    ),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ChangeEmailScreen();
                          },
                        ),
                      );
                    },
                    title: Text(
                      "Change email",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      'Update your email',
                    ),
                    // trailing: Text(
                    //   'Edit',
                    // ),
                  ),
                  ListTile(
                    title: Text(
                      "Change password",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      'Update your password',
                    ),
                    // trailing: Text(
                    //   'Edit',
                    // ),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return DefaultBusinessScreen();
                          },
                        ),
                      );
                    },
                    title: Text(
                      "Business",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      'Choose default business',
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.store,
                        size: 20.0,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return DefaultBusinessScreen();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  // Divider(),
                  // ListTile(
                  //   onTap: () {
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(
                  //         builder: (BuildContext context) {
                  //           return HistoryScreen();
                  //         },
                  //       ),
                  //     );
                  //   },
                  //   title: Text(
                  //     "History",
                  //     style: TextStyle(
                  //       fontSize: 17,
                  //       fontWeight: FontWeight.w700,
                  //     ),
                  //   ),
                  //   subtitle: Text(
                  //     'View list of scanned customer',
                  //   ),
                  //   trailing: IconButton(
                  //     icon: Icon(
                  //       Icons.history,
                  //       size: 20.0,
                  //     ),
                  //     onPressed: () {
                  //       Navigator.of(context).push(
                  //         MaterialPageRoute(
                  //           builder: (BuildContext context) {
                  //             return HistoryScreen();
                  //           },
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Logout"),
                              content: Text("You are about to logout."),
                              actions: <Widget>[
                                new FlatButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                                new FlatButton(
                                    child: _isLoading
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
                                        : const Text('Logout'),
                                    onPressed: () {
                                      logout();
                                    })
                              ],
                            );
                          });
                    },
                    title: Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      'Logout to your account',
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.redAccent,
                        size: 20.0,
                      ),
                      onPressed: () {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Logout"),
                                content: Text("You are about to logout."),
                                actions: <Widget>[
                                  new FlatButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                  new FlatButton(
                                      child: _isLoading
                                          ? Center(
                                              child: SizedBox(
                                                child:
                                                    CircularProgressIndicator(
                                                  backgroundColor: Colors.white,
                                                  strokeWidth: 2.0,
                                                ),
                                                height: 15.0,
                                                width: 15.0,
                                              ),
                                            )
                                          : const Text('Logout'),
                                      onPressed: () {
                                        logout();
                                      })
                                ],
                              );
                            });
                      },
                      tooltip: "Edit",
                    ),
                  ),

                  SizedBox(height: 80.0),
                  // MediaQuery.of(context).platformBrightness == Brightness.dark
                  //     ? SizedBox()
                  //     : ListTile(
                  //         title: Text(
                  //           "Dark Theme",
                  //           style: TextStyle(
                  //             fontSize: 17,
                  //             fontWeight: FontWeight.w700,
                  //           ),
                  //         ),
                  //         trailing: Switch(
                  //           value: Provider.of<AppProvider>(context).theme ==
                  //                   Constants.lightTheme
                  //               ? false
                  //               : true,
                  //           onChanged: (v) async {
                  //             if (v) {
                  //               Provider.of<AppProvider>(context, listen: false)
                  //                   .setTheme(Constants.darkTheme, "dark");
                  //             } else {
                  //               Provider.of<AppProvider>(context, listen: false)
                  //                   .setTheme(Constants.lightTheme, "light");
                  //             }
                  //           },
                  //           activeColor: Theme.of(context).accentColor,
                  //         ),
                  //       ),
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
                  content: hasConnection
                      ? Image.network(path)
                      : Text(
                          "Unable to fetch code. There is no internet connection.",
                          textAlign: TextAlign.center,
                        ),
                  actions: <Widget>[
                    new FlatButton(
                        child: const Text('Export'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    new FlatButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                );
              });
        },
        label: Text('My QR'),
        icon: Icon(Icons.camera),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
