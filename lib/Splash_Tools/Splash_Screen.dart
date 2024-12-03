import 'dart:async';

import 'package:christmas_project/MainPage/MainPage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
              (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/splash_screen/splash.jpg"
                ),
                fit: BoxFit.cover,
              )
            ),
          ),
             Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
                        child: Column(
                      children: <Widget>[
                        Transform.rotate(
                          angle: - 0 * 3.14159 / 180,
                          child: const Text(
                          "EMERGENCIA",
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 45.0,
                              color: Colors.white),
                        ),
                        ),
                         Transform.rotate(
                          angle: - 0 * 3.14159 / 180,
                          child: const Text(
                          "NAVIDEÑA",
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 45.0,
                              color: Colors.white),
                        ),
                        ),
                        Transform.rotate(
                          angle: - 0 * 3.14159 / 180,
                          child: const Text(
                          "-ESCAPE ROOM-",
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 45.0,
                              color: Colors.white),
                        )
                        ),
                        Padding(padding: EdgeInsets.only(top:150.0)),
                        CircularProgressIndicator(backgroundColor: Colors.lightGreen,strokeWidth: 15.0,),
                        
                      ],
                    ),
                    )
                    
                  )
                ],
              ),
        ],
      ),
    );
  }
}