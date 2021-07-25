import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialmedia/Authentication/login.dart';
import 'package:socialmedia/Navigation.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var colr;
  bool usercheck = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // usercheck = getData();
    Timer(Duration(seconds: 2), () {
      // usercheck = getData();
      directLogin();
    });
  }

  directLogin() async {
    print("Xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    // getData();
    var collectionRef = FirebaseFirestore.instance.collection('users');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('email');
    prefs.getString('pass');
    var doc = await collectionRef.doc(id).get();
    setState(() {
      usercheck = doc.exists;
    });

    if (usercheck) {
      if (usercheck) {
        print('fuid');
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Navigation()));
      } else {
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => login()));
      }
    } else {
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/EU.png'),
                  ),
                ), // child: Text(provider.uid),
              ),
              // Center(
              //   child: Container(
              //     height: MediaQuery.of(context).size.height / 2.5,
              //     width: MediaQuery.of(context).size.width,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.all(Radius.circular(20)),
              //     ),
              //     child: Text(
              //       "Europhic",
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 30,
              //           fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText('Loading...',
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                // ScaleAnimatedText(
                //   'Then Scale',
                //   textStyle:
                //       TextStyle(fontSize: 70.0, fontFamily: 'Canterbury'),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // getData() async {
  //   var collectionRef = FirebaseFirestore.instance.collection('users');
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.getString('email');
  //   prefs.getString('pass');
  //   var doc = await collectionRef.doc().get();
  //   setState(() {
  //     usercheck = doc.exists;
  //   });
  // }
}
