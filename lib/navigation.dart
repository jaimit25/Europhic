import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialmedia/Friends/request.dart';
import 'package:socialmedia/Tabs/home.dart';
import 'package:socialmedia/profiles/profile.dart';

var color = Colors.white;

class Navigation extends StatefulWidget {
  @override
  NavigationState createState() => NavigationState();
}

class NavigationState extends State<Navigation> {
  int bottomSelectedIndex = 0;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      // physics: new NeverScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: (index) {
        setState(() {
          bottomSelectedIndex = index;
        });
        pageChanged(index);
      },
      children: <Widget>[home(), request(), profile()],
    );
  }

  Color theme_main;
  Color theme_text;
  Color theme_icon;
  Color theme_navigation;
  ScrollController _arrowsController = ScrollController();

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  // bool a = false;
  bool a = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    App_theme();
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    onWillPop() {}
    // var provider = Provider.of<ProviderData>(context);
    return WillPopScope(
        child: Scaffold(
          // appBar: AppBar(
          //   backgroundColor: Colors.indigo[900],
          // ),
          body: buildPageView(),
          // bottomNavigationBar: CurvedNavigationBar(
          //   color: theme_navigation,
          //   backgroundColor: theme_main,
          //   buttonBackgroundColor: theme_navigation,
          //   index: bottomSelectedIndex,
          //   items: [
          //     Icon(
          //       Icons.home,
          //       color: theme_icon,
          //     ),
          //     Icon(
          //       Icons.person_add,
          //       color: theme_icon,
          //     ),
          //     Icon(
          //       Icons.account_circle,
          //       color: theme_icon,
          //     )
          //   ],
          //   onTap: (index) {
          //     bottomTapped(index);
          //   },
          // ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: theme_main,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: theme_icon,
                  ),
                  label: 'Home'
                  // title: Text('Home', style: styl),
                  ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person_add,
                    color: theme_icon,
                  ),
                  label: 'Friends'

                  // title: Text('Friends', style: styl),
                  ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.account_circle,
                    color: theme_icon,
                  ),
                  label: 'You'
                  // title: Text('You', style: styl),
                  ),
            ],
            currentIndex: bottomSelectedIndex,
            fixedColor: theme_main,
            onTap: (index) {
              bottomTapped(index);
            },
          ),
        ),
        onWillPop: onWillPop);
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
        theme_main = Colors.black;
        theme_text = Colors.white;
        theme_icon = Colors.white;
        theme_navigation = Colors.grey[900];
      });
    } else {
      setState(() {
        theme_main = Colors.white;
        theme_text = Colors.black;
        theme_icon = Colors.black;
        theme_navigation = Colors.grey[200];
      });
    }
  }
}

TextStyle styl = new TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w300,
);
