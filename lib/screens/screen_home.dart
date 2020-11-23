import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _formKey2 = GlobalKey<FormState>();

  showFilter() async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: const EdgeInsets.all(20.0),
          content: new SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: _formKey2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.keyboard_backspace),
                            color: Color.fromRGBO(236, 138, 92, 1),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Reset",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              height: 20,
              color: Colors.transparent,
              textColor: Color.fromRGBO(236, 138, 92, 1),
              padding: EdgeInsets.all(8.0),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            FlatButton(
              height: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(color: Color.fromRGBO(236, 138, 92, 1))),
              color: Color.fromRGBO(236, 138, 92, 1),
              textColor: Colors.white,
              padding: EdgeInsets.all(8.0),
              onPressed: () {
                if (_formKey2.currentState.validate()) {
                  Navigator.pop(context);
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
            padding: EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 0),
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(
                              color: Color.fromRGBO(236, 138, 92, 1))),
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
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.location_on_outlined,
                                    color: Colors.white),
                                Text(
                                  "Albay, Bicol",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(Icons.keyboard_arrow_down,
                                    color: Colors.white),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 140),
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                          ),
                          elevation: 3.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.0),
                              ),
                            ),
                            child: TextFormField(
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.5)),
                                contentPadding: EdgeInsets.all(10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                hintText: "Search deals",
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black54,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    showFilter();
                                  },
                                  icon: Icon(Icons.filter_list),
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                              obscureText: false,
                              maxLines: 1,
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                      ),
                    ]),
              ],
            )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
