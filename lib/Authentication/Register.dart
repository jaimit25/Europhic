import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialmedia/Authentication/login.dart';
import 'package:socialmedia/Navigation.dart';

import 'dart:async';
import 'dart:ui';

class register extends StatefulWidget {
  // const register({ Key? key }) : super(key: key);

  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  bool _passwordVisible;

  TextEditingController emailCont = new TextEditingController();
  TextEditingController passCont = new TextEditingController();
  TextEditingController nameCont = new TextEditingController();
  TextEditingController usernameCont = new TextEditingController();

  bool isObsecure = true;
  // File _image;
  bool isloading = false;
  bool userValid = false;
  var myLocation;
  double lat = 0, lng = 0;
  var Add = 'Address';

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
    getUserLocation();
    // initializeFCM();
  }

  getUserLocation() async {
    //call this async method from whereever you need

    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    // currentLocation = myLocation;
    final coordinates =
        new Coordinates(myLocation.latitude, myLocation.longitude);
    print(myLocation.latitude);
    print(myLocation.longitude);
    setState(() {
      lat = myLocation.latitude;
      lng = myLocation.longitude;
    });
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(
        ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    setState(() {
      Add =
          ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}';
    });
    return first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          SizedBox(
            height: 80,
          ),
          Container(
            padding: EdgeInsets.only(left: 30),
            height: 50,
            child: Text(
              'Create Account',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 35),
            height: 70,
            child: Text(
              'please fill the input below here',
              maxLines: 2,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 35, right: 35),
            child: TextFormField(
              maxLines: 2,
              // onSaved: (_input) {
              //   setState(() {
              //     _name.text = _input;
              //   });
              // },
              controller: nameCont,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "NAME",
                labelStyle: TextStyle(
                    color: Colors.grey, letterSpacing: 0.8, fontSize: 15),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.only(left: 35, right: 35),
            child: TextFormField(
              maxLines: 2,
              controller: usernameCont,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "USERNAME",
                labelStyle: TextStyle(
                    color: Colors.grey, letterSpacing: 0.8, fontSize: 15),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.only(left: 35, right: 35),
            child: TextFormField(
              maxLines: 2,
              // onSaved: (input) {
              //   setState(() {
              //     _email.text = input;
              //   });
              // },
              controller: emailCont,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "EMAIL",
                labelStyle: TextStyle(
                    color: Colors.grey, letterSpacing: 0.8, fontSize: 15),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.only(left: 35, right: 35),
            child: TextFormField(
              obscureText: _passwordVisible,
              // onSaved: (_input) {
              //   setState(() {
              //     _password.text = _input;
              //   });
              // },
              // maxLines: 2,
              controller: passCont,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.blue),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    }),
                labelText: "PASSWORD",
                labelStyle: TextStyle(
                    color: Colors.grey, letterSpacing: 0.8, fontSize: 15),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () async {
              print("Registering Button Clicked");

              //check if email is valid
              bool emailValid =
                  RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                      .hasMatch(emailCont.text);
              print(emailValid);

              //check user exist
              bool check = false;

              var collectionRef =
                  FirebaseFirestore.instance.collection('users');
              var docu = await collectionRef.doc(emailCont.text).get();
              // var users = await collectionRef.doc(emailCont.text).snapshots();
              check = docu.exists;
              if (check) {
                Fluttertoast.showToast(
                    msg: "User Already Exist please Login",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                if (emailValid) {
                  if (nameCont.text != null &&
                          // nameCont.text != '' &&
                          usernameCont.text != null &&
                          // usernameCont.text != '' &&
                          emailCont.text != null &&
                          // emailCont.text != '' &&
                          passCont.text != null
                      // &&
                      // passCont.text != ''
                      ) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(emailCont.text)
                        .set({
                      'email': emailCont.text,
                      'name': nameCont.text,
                      'pass': passCont.text,
                      'photo':
                          'https://www.cybersport.ru/assets/img/no-photo/user.png',
                      'username': usernameCont.text,
                      'call': false,
                      'phone': 'Enter Phone Number',
                      'birthdate': 'Enter Birth Date',
                      'extra': 0,
                      'Privacy': 0,
                      'extra1': 'abc',
                      'val': 'value',
                      'checkval': 'value',
                      'searchname': nameCont.text.toLowerCase(),
                      'lat': lat == null ? 34.0479 : lat,
                      'lng': lng == null ? 100.6197 : lng,
                      'address': Add == null || Add == '' ? 'Address' : Add
                      // .substring(0, 50)
                      ,
                    }).then((value) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('email', emailCont.text);
                      prefs.setString('pass', passCont.text);
                      // prefs.setString('name', nameCont.text);
                      // prefs.setString('username', usernameCont.text);
                      prefs.setBool('theme', true);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Navigation(),
                        ),
                      );
                    }).catchError((e) {
                      Fluttertoast.showToast(
                          msg:
                              "Error Registering🙁! Please Try Again After Sometime",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.SNACKBAR,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    });
                  } else {
                    print(nameCont.text);
                    print(usernameCont.text);
                    print(emailCont.text);
                    print(passCont.text);
                    Fluttertoast.showToast(
                        msg: "Please Enter All Field",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    print('enter all fields');
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: "Enter valid Email Address",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              }
            },
            child: Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 35),
              height: 50,
              width: double.infinity,
              color: Colors.blue,
              child: Text(
                'REGISTER',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => login()));
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              // padding: EdgeInsets.only(left: 35),
              padding: EdgeInsets.all(5),
              height: 50,
              child: Text(
                'Already a user ? Login Now',
                maxLines: 2,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
