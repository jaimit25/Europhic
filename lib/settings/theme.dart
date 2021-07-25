import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialmedia/Authentication/splash.dart';

class theme extends StatefulWidget {
  // const theme({ Key? key }) : super(key: key);

  @override
  _themeState createState() => _themeState();
}

class _themeState extends State<theme> {
  Color theme_main;
  Color theme_text;
  Color theme_icon;

  int _radioValue = 3;

  // bool a = false;
  bool a = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Timer timer = Timer.periodic(Duration(milliseconds: 900), (Timer t) {
    //   setState(() {});
    // });

    App_theme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme_main,
      appBar: AppBar(
        backgroundColor: theme_main,
        elevation: 0.5,
        title: Text(
          'Set Theme',
          style: TextStyle(
            color: theme_text,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(shrinkWrap: true, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.color_lens,
                  color: theme_icon,
                ),
                title: Text(
                  'Dark Theme',
                  style: TextStyle(color: theme_text),
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool('theme', true);
                  var theme = prefs.getBool('theme');
                  if (theme) {
                    print('dark theme');
                  } else {
                    print('light theme');
                  }
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SplashScreen()));
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  height: 3.0,
                  thickness: 0.5,
                  color: Colors.grey[500],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.color_lens,
                  color: theme_icon,
                ),
                title: Text(
                  'Light Theme',
                  style: TextStyle(color: theme_text),
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool('theme', false);
                  var theme = prefs.getBool('theme');
                  if (theme) {
                    print('dark theme');
                  } else {
                    print('light theme');
                  }
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SplashScreen()));
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  height: 3.0,
                  thickness: 0.5,
                  color: Colors.grey[500],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.color_lens,
                  color: theme_icon,
                ),
                title: Text(
                  'System default ',
                  style: TextStyle(color: theme_text),
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool('theme', true);
                  var theme = prefs.getBool('theme');
                  if (theme) {
                    print('dark theme');
                  } else {
                    print('light theme');
                  }
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SplashScreen()));
                },
              ),
            ],
          ),
        ]),
      ),
    );
  }

  getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('name', nameCont.text);
    // prefs.setString('username', usernameCont.text);
    setState(() {
      a = prefs.getBool('theme');
    });
  }

  App_theme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('name', nameCont.text);
    // prefs.setString('username', usernameCont.text);
    setState(() {
      a = prefs.getBool('theme');
    });
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
}
