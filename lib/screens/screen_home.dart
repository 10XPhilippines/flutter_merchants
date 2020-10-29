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

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home>{

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(

    );
  }

  @override
  bool get wantKeepAlive => true;
}
