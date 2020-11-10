import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_merchants/screens/screen_signup.dart';
import 'package:flutter_merchants/screens/screen_signin.dart';
import 'package:flutter_merchants/screens/screen_forgot.dart';


class Walkthrough extends StatefulWidget {
  @override
  _WalkthroughState createState() => _WalkthroughState();
}

class _WalkthroughState extends State<Walkthrough> {
  List pageInfos = [
    {
      "title": "Exciting Deals",
      "body":
          "You deserve to get everything businesses have to offer you, your family, and your budget.",
      "img": "assets/on1.png",
    },
    {
      "title": "Secure Visits",
      "body":
          "You'll never have to sign those contact tracing again and again.",
      "img": "assets/on2.png",
    },
    {
      "title": "Secure Visits",
      "body":
          "You'll never have to sign those contact tracing again and again.",
      "img": "assets/on3.png",
    },
  ];
  @override
  Widget build(BuildContext context) {
    List<PageViewModel> pages = [
      for (int i = 0; i < pageInfos.length; i++) _buildPageModel(pageInfos[i])
    ];

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(236, 138, 92, 1),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: IntroductionScreen(
            pages: pages,
            onDone: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    // return JoinApp();
                    return SigninScreen();
                    // return SignupScreen();
                    // return ForgotScreen();
                  },
                ),
              );
            },
            onSkip: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return SigninScreen();
                  },
                ),
              );
            },
            showSkipButton: false,
            skip: Text("Skip"),
            next: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
              child: Icon(Icons.arrow_forward, size: 15),
            ),
            done: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
              child: Icon(Icons.check_sharp, size: 15),
            ),
            dotsDecorator: DotsDecorator(
              activeColor: Colors.white,
              color: Colors.white54,
              spacing: const EdgeInsets.symmetric(horizontal: 10.0),
            ),
            dotsFlex: 2,
          ),
        ),
      ),
    );
  }

  _buildPageModel(Map item) {
    return PageViewModel(
      title: item['title'],
      body: item['body'],
      image: Image.asset(
        item['img'],
        height: 185.0,
      ),
      decoration: PageDecoration(
        contentPadding: EdgeInsets.all(40),
        titleTextStyle: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        bodyTextStyle: TextStyle(
          fontSize: 15.0,
          color: Colors.white,
        ),
//        dotsDecorator: DotsDecorator(
//          activeColor: Theme.of(context).accentColor,
//          activeSize: Size.fromRadius(8),
//        ),
        pageColor: Color.fromRGBO(236, 138, 92, 1),
      ),
    );
  }
}
