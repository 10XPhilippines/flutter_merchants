import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_merchants/screens/dishes.dart';
import 'package:flutter_merchants/widgets/grid_product.dart';
import 'package:flutter_merchants/widgets/home_category.dart';
import 'package:flutter_merchants/widgets/slider_item.dart';
import 'package:flutter_merchants/util/foods.dart';
import 'package:flutter_merchants/util/categories.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
  Map profile = {};
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  getProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString("user");
    setState(() {
      profile = json.decode(data);
    });
    print(profile);
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
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0),
        child: ListView(
          children: <Widget>[
            FlatButton(
                height: 300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(color: Color.fromRGBO(236, 138, 92, 1))),
                color: Color.fromRGBO(236, 138, 92, 1),
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                onPressed: () {},
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Text(
                          "User Profile",
                          style: TextStyle(
                              color: Color.fromRGBO(21, 26, 70, 1),
                              fontSize: 25,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ])),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
