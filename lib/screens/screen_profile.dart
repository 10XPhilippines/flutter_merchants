import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_merchants/network_utils/api.dart';
import 'package:flutter_merchants/screens/dishes.dart';
import 'package:flutter_merchants/widgets/grid_product.dart';
import 'package:flutter_merchants/widgets/home_category.dart';
import 'package:flutter_merchants/widgets/slider_item.dart';
import 'package:flutter_merchants/util/foods.dart';
import 'package:flutter_merchants/util/categories.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
  Map profile = {};
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateFormat formatter = DateFormat('EEE, MMM d, yyyy hh:mm aaa');
  int userId = 0;
  bool _isLoading = false;
  String image, name;
  String pn, fn, ln, fb, g;

  getProfile() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString("user");
    setState(() {
      profile = json.decode(data);
      image = Network().qrCode() + profile["image"];
      userId = int.parse(profile["id"].toString());
      name = profile["name"];
      _isLoading = false;
    });
    print(image);
    print(profile);
    getUserData(userId.toString());
  }

  Future getUserData(String id) async {
    setState(() {
      _isLoading = true;
    });
    var res = await Network().getData('/user/' + id.toString());
    var body = json.decode(res.body);
    print(body);
    if (body['success'] == true) {
      setState(() {
        pn = body["user"]["phone"];
        fn = body["user"]["first_name"];
        ln = body["user"]["last_name"];
        fb = body["user"]["facebook_id"];
        g = body["user"]["google_id"];
        _isLoading = false;
      });
    }
  }

  Text getMyText() {
    if (g != null) {
      return Text(
        'Signed in thru Google',
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
      );
    } else if (fb != null) {
      return Text(
        'Signed in thru Facebook',
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
      );
    } else {
      return Text(
        'Signed in thru Email',
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
      );
    }
  }

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(
                                color: Color.fromRGBO(236, 138, 92, 1))),
                        color: Color.fromRGBO(236, 138, 92, 1),
                        child: ListView(shrinkWrap: true, children: <Widget>[
                          Center(
                            child: Text(
                              "User Profile",
                              style: TextStyle(
                                  color: Color.fromRGBO(21, 26, 70, 1),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: new CircleAvatar(
                              child: ClipOval(
                                child: Image.network(
                                  image ??
                                      "https://img.icons8.com/fluent/48/000000/user-male-circle.png",
                                ),
                              ),
                              radius: 60.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 10),
                            child: fn == null || ln == null
                                ? Text(
                                    name,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700),
                                  )
                                : Text(
                                    "$fn $ln",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700),
                                  ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 10),
                            child: Text(
                              formatter.format(
                                  DateTime.parse(profile["created_at"])),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 10),
                            child: getMyText(),
                          ),
                          SizedBox(height: 30),
                        ])),
                    GridView.count(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.all(30),
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 4),
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: const Text("He'd have you all unravel at the"),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: const Text("He'd have you all unravel at the"),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(0),
                          child: const Text("Deals Availed"),
                          constraints: BoxConstraints(maxHeight: 2, maxWidth: 2),
                        ),
                        Container(
                          padding: const EdgeInsets.all(0),
                          child: const Text("Favorites"),
                          constraints: BoxConstraints(maxHeight: 2, maxWidth: 2),
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: const Text("He'd have you all unravel at the"),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: const Text("He'd have you all unravel at the"),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
