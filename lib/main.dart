import 'package:flutter/material.dart';
import 'package:flutter_merchants/screens/screen_checkout.dart';
import 'package:provider/provider.dart';
import 'package:flutter_merchants/providers/app_provider.dart';
import 'package:flutter_merchants/util/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/main_screen.dart';
import 'screens/login.dart';
import 'screens/splash.dart';
import 'util/const.dart';

import 'screens/profile.dart';



void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, Widget child) {
        return MaterialApp(
          key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: appProvider.navigatorKey,
          title: Constants.appName,
          theme: appProvider.theme,
          darkTheme: Constants.darkTheme,
          home: CheckAuth(),
        );
      },
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  bool checkoutShared = false;
  @override
  void initState() {
    // checkIfCheckoutSharedPref();
    _checkIfLoggedIn();
    
    super.initState();
  }

  Future checkIfCheckoutSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String checkout = prefs.getString("checkout");
    print("Checkout: $checkout");
    print("checkoutShared: $checkoutShared");
    setState(() {
      checkoutShared = true;
    });
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return MainScreen();
            },
          ),
        );
      });
    } else {
      child = SplashScreen();
    }
    return Scaffold(
      body: child,
    );
  }
}
