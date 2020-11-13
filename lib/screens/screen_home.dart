import 'package:flutter/material.dart';
import 'package:flutter_merchants/screens/dishes.dart';
import 'package:flutter_merchants/widgets/grid_product.dart';
import 'package:flutter_merchants/widgets/home_category.dart';
import 'package:flutter_merchants/widgets/slider_item.dart';
import 'package:flutter_merchants/util/foods.dart';
import 'package:flutter_merchants/util/categories.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(color: Color.fromRGBO(236, 138, 92, 1))),
                color: Color.fromRGBO(236, 138, 92, 1),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 18, right: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.menu, color: Colors.white),
                          Icon(Icons.notifications, color: Colors.white),
                        ],
                      ),
                    ),
                    Center(
                      child: Text(
                        "10X Philippines",
                        style: TextStyle(
                            color: Color.fromRGBO(21, 26, 70, 1),
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
