import 'package:flutter/material.dart';
import 'package:flutter_merchants/screens/dishes.dart';
import 'package:flutter_merchants/widgets/grid_product.dart';
import 'package:flutter_merchants/widgets/home_category.dart';
import 'package:flutter_merchants/widgets/slider_item.dart';
import 'package:flutter_merchants/util/foods.dart';
import 'package:flutter_merchants/util/categories.dart';
import 'package:carousel_slider/carousel_slider.dart';


class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with AutomaticKeepAliveClientMixin<ScanScreen>{

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(

    );
  }

  @override
  bool get wantKeepAlive => true;
}
