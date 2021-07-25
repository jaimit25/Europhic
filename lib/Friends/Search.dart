import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialmedia/profiles/user_profile.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Color theme_main;
  Color theme_text;
  Color theme_icon;
  Color theme_navigation;
  TextEditingController _searchController = TextEditingController();
  var searchsnapshot;
  QuerySnapshot searchResultSnapshot;
  TextEditingController searchEditingController = new TextEditingController();
  bool isLoading = false;
  bool haveUserSearched = false;
  var Data;
  String uiduser;
  var email;

  @override
  void initState() {
    super.initState();
    App_theme();
    // Future.delayed(Duration(milliseconds: 2), () {
    //   setState(() {});
    // });
    // Data = FirebaseFirestore.instance.collection('users').snapshots();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  // bool a = false;
  bool a = true;

  @override
  Widget build(BuildContext context) {
    onWillPop() {
      Navigator.pop(context);
    }

    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: theme_main,
          appBar: AppBar(
            elevation: 0.2,
            backgroundColor: theme_main,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: theme_icon)),
          ),
          body: ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 50,
                margin:
                    EdgeInsets.only(top: 10, bottom: 10, right: 12, left: 12),
                padding: EdgeInsets.only(top: 2, bottom: 2, right: 5, left: 7),
                decoration: BoxDecoration(
                    color: theme_navigation,
                    // border: Border.all(width: 1, color: , s
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: TextFormField(
                  style: TextStyle(color: theme_text),

                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (value) {
                    // Fluttertoast.showToast(
                    //     msg: "This is Center Short Toast",
                    //     toastLength: Toast.LENGTH_SHORT,
                    //     gravity: ToastGravity.CENTER,
                    //     timeInSecForIosWeb: 1,
                    //     backgroundColor: Colors.red,
                    //     textColor: Colors.white,
                    //     fontSize: 16.0);

                    setState(() {
                      haveUserSearched = !haveUserSearched;
                    });
                  },
                  // controller: _searchController,
                  controller: _searchController,
                  onChanged: (query) {
                    // searchUser(query);
                    setState(() {
                      haveUserSearched = !haveUserSearched;
                    });
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: theme_icon),
                      hintText: 'Search ...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      border: InputBorder.none),
                ),
              ),
              userList(),
            ],
          ),
        ),
        onWillPop: onWillPop);
  }

  Widget userList() {
    return haveUserSearched
        ? StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where('searchname',
                    isGreaterThanOrEqualTo:
                        _searchController.text.toLowerCase())
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                shrinkWrap: true,
                children: snapshot.data.docs.map<Widget>((document) {
                  return FriendList(document['photo'], document['username'],
                      document['name'], document['email']);
                }).toList(),
              );
            },
          )
        : Center(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('UserSearched')
                  .where('mail', isEqualTo: email)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  shrinkWrap: true,
                  reverse: true,
                  children: snapshot.data.docs.map<Widget>((document) {
                    // return Container();
                    // return Divider(
                    //   height: 2,
                    //   color: Colors.black,
                    // );
                    return userTileDelete(
                        document['userName'],
                        document['Name'],
                        document['UserEmail'],
                        document['Photo'],
                        document.id);
                  }).toList(),
                );
              },
            ),
          );
  }

  Widget userTileDelete(
      String userName, String Name, String userEmail, String Photo, String id) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => user_profile(
                      useremail: userEmail,
                    )));
      },
      // hoverColor: theme_navigation,
      child: Container(
          child: Column(
        children: [
          Container(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => user_profile(
                              useremail: userEmail,
                            )));
              },
              child: Container(
                // color: Colors.pink,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  // color: Colors.pink
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // border: Border.all(width: 3, color: Colors.pink),
                          image: DecorationImage(
                              image: NetworkImage(Photo), fit: BoxFit.cover)),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 160,
                            child: Text(
                              Name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: theme_text,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            width: 120,
                            child: Text(
                              userName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: theme_text,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: theme_text),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('UserSearched')
                            .doc(id)
                            .delete();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(left: 30, right: 30),
          //   child: Divider(
          //     height: 5,
          //     color: Colors.white,
          //   ),
          // )
        ],
      )),
    );
  }

  Widget FriendList(String userimg, String username, String name, String mail) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var myemail = prefs.getString('email');
        FirebaseFirestore.instance
            .collection('UserSearched')
            .doc(name + mail)
            .set({
          'Name': name,
          'Photo': userimg,
          'UserEmail': mail,
          'mail': myemail,
          'userName': username
        }).then((value) async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => user_profile(
                        useremail: mail,
                      )));
        });
        //
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          margin: EdgeInsets.only(top: 10, left: 10),
          height: 80,
          // color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(5),
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(userimg),
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    child: Text(
                      username,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: theme_text,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    width: 150,
                    child: Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  App_theme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('name', nameCont.text);

    setState(() {
      email = prefs.getString('email');
      print(email);
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

  void DialogBox2(context) {
    var baseDialog = AlertDialog(
      title: new Text("Warning"),
      content: Container(
        child: Text('Enter All The Fields'),
      ),
      actions: <Widget>[
        FlatButton(
          color: theme_main,
          child: new Text("Back",
              style: TextStyle(
                color: theme_icon,
              )),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }
}
