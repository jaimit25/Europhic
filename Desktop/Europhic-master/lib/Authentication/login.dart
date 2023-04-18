import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialmedia/Authentication/Register.dart';
import 'package:socialmedia/Navigation.dart';

class login extends StatefulWidget {
  // const login({ Key? key }) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  bool _passwordVisible;
  TextEditingController emailCont = new TextEditingController();
  TextEditingController passCont = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
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
            padding: EdgeInsets.only(left: 35),
            height: 50,
            child: Text(
              'Hello,',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 35),
            height: 70,
            child: Text(
              'Welcome Back',
              maxLines: 2,
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 35, right: 35),
            child: TextFormField(
              maxLines: 2,
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
              if (emailCont.text != null && passCont.text != null) {
                var collectionRef =
                    FirebaseFirestore.instance.collection('users');
                var docu = await collectionRef.doc(emailCont.text).get();
                // var users = await collectionRef.doc(emailCont.text).snapshots();
                bool check = docu.exists;
                var dc = docu.data();
                if (check) {
                  if (dc['pass'] == passCont.text) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('email', emailCont.text);
                    prefs.setString('pass', passCont.text);
                    prefs.setBool('theme', true);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Navigation(),
                      ),
                    );
                  } else {
                    Fluttertoast.showToast(
                        msg: "Wrong Password",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    print('wrong data');
                  }
                } else {
                  //email dosent exist
                  Fluttertoast.showToast(
                      msg: "Invalid Fields",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              } else {
                Fluttertoast.showToast(
                    msg: "Enter All Fields",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
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
                'LOGIN',
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
                  context, MaterialPageRoute(builder: (context) => register()));
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              // padding: EdgeInsets.only(left: 35),
              padding: EdgeInsets.all(5),
              height: 50,
              child: Text(
                'Don\'t have an Account ? Register Now',
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
