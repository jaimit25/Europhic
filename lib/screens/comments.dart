import 'package:flutter/material.dart';

class comments extends StatefulWidget {
  // const comments({ Key? key }) : super(key: key);

  @override
  _commentsState createState() => _commentsState();
}

class _commentsState extends State<comments> {
  @override
  Widget build(BuildContext context) {
    Color theme_main;
    Color theme_text;
    Color theme_icon;

    // bool a = false;
    bool a = true;

    App_theme() {
      if (a) {
        print("object");
        setState(() {
          theme_main = Color(0XFF000000);
          theme_text = Colors.white;
          theme_icon = Colors.white;
        });
      } else {
        // print("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
        setState(() {
          theme_main = Colors.white;
          theme_text = Colors.black;
          theme_icon = Colors.black;
        });
      }
    }

    @override
    void initState() {
      // TODO: implement initState
      super.initState();

      // Timer timer = Timer.periodic(Duration(milliseconds: 900), (Timer t) {
      //   setState(() {});
      // });

      App_theme();
    }

    return Scaffold();
  }
}
