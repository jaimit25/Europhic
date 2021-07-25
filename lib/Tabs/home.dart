import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialmedia/Model/FollowersModel.dart';
import 'package:socialmedia/Model/FollowingModel.dart';
import 'package:socialmedia/Model/Post.dart';
import 'package:socialmedia/Tabs/feed.dart';
import 'package:socialmedia/chats/Componenets/chat_pages.dart';

class home extends StatefulWidget {
  // const home({Key key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  Color theme_main;
  Color theme_text;
  Color theme_icon;

  // bool a = false;
  bool a = true;
  var email;
  List<Post> feedList = [];

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Timer timer = Timer.periodic(Duration(milliseconds: 900), (Timer t) {
    //   setState(() {});
    // });

    App_theme();
    getEmail();
    getdata();
    // getTheme();
  }

  getdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var mymail = pref.getString('email');
    print('get data function run');

    //creating list
    List<Post> Postlist = [];
    List<FollowersModel> followerslist = [];
    List<FollowingModel> followinglist = [];

    //getting list of my post + followers + following to create a feed list which will be shown

    //Post List mine
    await FirebaseFirestore.instance
        .collection("Post")
        // .where('email', isEqualTo: mymail)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Postlist.add(Post(
          userPhoto: doc['userPhoto'],
          text: doc['text'],
          type: doc['type'],
          image: doc['image'],
          email: doc['email'],
          comments: doc['comments'],
          DateTime: doc['DateTime'],
          lat: doc['lat'],
          lng: doc['lng'],
          track: doc['track'],
          address: doc['address'],
          name: doc['name'],
        ));
      });
    });
    print(Postlist.length);
    for (int i = 0; i < Postlist.length; i++) {
      print('running For Loop');
      print(Postlist[i].userPhoto);
      print(Postlist[i].text);
      print(Postlist[i].type);
      print(Postlist[i].image);
      print(Postlist[i].email);
      print(Postlist[i].comments);
      print(Postlist[i].lat);
      print(Postlist[i].lng);
      print(Postlist[i].address);
    }

    print("Creating Following List \n \n \n");
    await FirebaseFirestore.instance
        .collection("Following")
        .doc(mymail)
        .collection("following")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        followinglist.add(FollowingModel(
            myemail: doc['myemail'],
            name: doc['name'],
            useremail: doc['useremail'],
            photo: doc['photo'],
            username: doc['username']));
      });
    });
    print(followinglist.length);
    for (int i = 0; i < followinglist.length; i++) {
      print('running For Loop');
      print(followinglist[i].myemail);
      print(followinglist[i].name);
      print(followinglist[i].useremail);
      print(followinglist[i].photo);
      print(followinglist[i].username);
    }

    print("Creating Followers List \n \n \n");
    await FirebaseFirestore.instance
        .collection("Followers")
        .doc(mymail)
        .collection("followers")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        followerslist.add(FollowersModel(
            myemail: doc['myemail'],
            name: doc['name'],
            useremail: doc['useremail'],
            userimg: doc['userimg'],
            username: doc['username']));
      });
    });
    print(followerslist.length);
    for (int i = 0; i < followerslist.length; i++) {
      print('running For Loop');
      print(followerslist[i].myemail);
      print(followerslist[i].name);
      print(followerslist[i].useremail);
      print(followerslist[i].userimg);
      print(followerslist[i].username);
    }

    //creating final post list
    //feedList = []; data type of feeList is Post
    setState(() {
      for (int i = 0; i < Postlist.length; i++) {
        print('running For Loop to add Post to Final List');
        // print(Postlist[i].email);

        // for (int j = 0; j < followerslist.length; j++) {
        //   if (Postlist[i].email == followerslist[j].useremail) {
        //     feedList.add(Postlist[i]);
        //   }
        // }
        for (int k = 0; k < followinglist.length; k++) {
          if (Postlist[i].email == followinglist[k].useremail) {
            feedList.add(Postlist[i]);
            print("added from following");
          }
        }
      }
    });
    //getting my post
    for (int k = 0; k < Postlist.length; k++) {
      if (Postlist[k].email == mymail) {
        // setState(() {
        feedList.add(Postlist[k]);
        print("added from email validity");
        // });
      }
    }
    for (int m = 0; m < feedList.length; m++) {
      print("*********************** printing final list *************");
      print(feedList[m].userPhoto);
      print(feedList[m].text);
      print(feedList[m].type);
      print(feedList[m].image);
      print(feedList[m].email);
      print(feedList[m].comments);
      print(feedList[m].lat);
      print(feedList[m].lng);
      print(feedList[m].address);
      print(feedList[m].name);
    }
    print(
        "************* length of feed list is : ${feedList.length} ******************");
  }

  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString("email");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme_main,
      appBar: AppBar(
        backgroundColor: theme_main,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (Context) => Addfeed()));
          },
          child: Icon(
            Icons.add_circle_outline,
            size: 30,
            color: theme_icon,
          ),
        ),
        title: Text(
          'Europhic',
          style: GoogleFonts.andika(
            textStyle: TextStyle(
                color: theme_text,
                letterSpacing: 2,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => chatpages()));
            },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.chat_outlined,
                size: 25,
                color: theme_icon,
              ),
            ),
          ),
        ],
        centerTitle: true,
        leadingWidth: 70,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var doc = snapshot.data;
            return ListView(
              shrinkWrap: true,
              children: [
                Container(
                  height: 150,
                  // width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        your_story(doc['photo']),
                        Container(
                          height: 150,
                          // width: double.infinity,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                storycircle(
                                  image:
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrutZP2ETTNAECOWVOqtYxiqushnwu7baAOQ&usqp=CAU',
                                ),
                                storycircle(
                                    image:
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFNu5npYNxRJL-In7ns6qf9U5JrxaqgUjgQQ&usqp=CAU'),
                                storycircle(
                                  image:
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOOFMe-CzzMAgkPdsGK1wsKLtoF33HXGK98A&usqp=CAU',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey[900],
                  child: ListView.builder(
                    primary: false,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: feedList.length,
                    itemBuilder: (context, index) {
                      print("generating list of size ${feedList.length}");
                      // return Container(
                      //     margin: EdgeInsets.only(top: 20),
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //     ),
                      //     child: Text("${feedList[index].name}"));

                      return Tile(
                        comments: feedList[index].comments,
                        email: feedList[index].email,
                        DateTime: feedList[index].DateTime,
                        type: feedList[index].type,
                        text: feedList[index].text,
                        image: feedList[index].image,
                        userPhoto: feedList[index].userPhoto,
                        name: feedList[index].name,
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  your_story(myphoto) {
    return GestureDetector(
      onTap: () {
        //add story
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 5,
              left: 10,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: a ? Colors.white : Colors.black45, width: 3),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(myphoto),
              ),
            ),
            height: 80,
            width: 80,
          ),
        ],
      ),
    );
  }
}

class Tile extends StatefulWidget {
  var userPhoto;
  var name;
  var text;
  var type;
  var image;
  var email;
  var comments;
  var DateTime;
  Tile({
    @required this.userPhoto,
    @required this.text,
    @required this.type,
    @required this.image,
    @required this.name,
    @required this.email,
    @required this.comments,
    @required this.DateTime,
  });
  @override
  _TileState createState() => _TileState(
      comments: this.comments,
      DateTime: this.DateTime,
      text: this.text,
      type: this.type,
      email: this.email,
      userPhoto: this.userPhoto,
      image: this.image,
      name: this.name);
}

class _TileState extends State<Tile> {
  var userPhoto;
  var name;
  var text;
  var type;
  String image;
  var email;
  var comments;

  var DateTime;
  _TileState({
    @required this.userPhoto,
    @required this.text,
    @required this.type,
    @required this.image,
    @required this.email,
    @required this.comments,
    @required this.DateTime,
    @required this.name,
  });

  bool open = true;
  var opa = 0.4;
  Color theme_main;
  Color theme_text;
  Color theme_icon;

  // bool a = false;
  bool a = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    App_theme();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          // setState(() {
          //   open = !open;
          // });
        },
        child: Container(
          // padding: EdgeInsets.only(left: 220, top: 50, bottom: 50),
          margin: EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 15),
          decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image
                    // 'https://i.pinimg.com/originals/6d/62/f0/6d62f0fb9edea6121981088f95ef5e53.jpg'
                    ),
                fit: BoxFit.cover,
              ),
              color: theme_main,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          // height: 420,
          height: 420,
          // width: 315,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              open
                  ? Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                bottomLeft: Radius.circular(50))),
                        margin: EdgeInsets.only(top: 50, bottom: 50),
                        width: 65,
                        // height: 260,
                        height: 280,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              // open = !open;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.black,
                                  size: 25,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: Icon(
                                  Icons.chat_bubble,
                                  color: Colors.black,
                                  size: 25,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: Icon(
                                  Icons.bookmark,
                                  color: Colors.black,
                                  size: 25,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  child: Transform.rotate(
                                    angle: 340 * 3.14 / 180,
                                    child: Icon(
                                      Icons.send,
                                      color: Colors.black,
                                      size: 25,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Container(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                        // border: Border.all(color: Colors.red)
                        ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          margin: EdgeInsets.only(top: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            'https://media.istockphoto.com/photos/real-macho-picture-id1014791458?k=6&m=1014791458&s=612x612&w=0&h=5lqphJFPseFoWMG2vrWlUTWl3OfuNiS-1Jd27vt1QjA='))),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 15, left: 10),
                                height: 50,
                                width: 200,
                                child: Text(
                                  name,
                                  // name == null || name == "" ? 'Name' : name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                      fontSize: 17),
                                ),
                              )
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.only(left: 20, top: 10),
                            // height: 100,
                            width: 300,
                            child: Text(
                              text == null || text == "" ? '...' : text,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.8,
                                  fontSize: 13),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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

class storycircle extends StatefulWidget {
  // const storycircle({ Key? key }) : super(key: key);
  var image;
  storycircle({@required this.image});
  @override
  _storycircleState createState() => _storycircleState(image: this.image);
}

class _storycircleState extends State<storycircle> {
  var image;
  _storycircleState({@required this.image});
  Timer timer;
  bool invert = false;

  var a = Color(0XFFf43b47);
  var b = Color(0XFF874da2);
  var c = Color(0XFFd09693);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: Colors.grey,
          width: 3,
        ),
      ),
    );
  }
}

final kInnerDecoration = BoxDecoration(
  color: Colors.white,
  border: Border.all(color: Colors.white),
  borderRadius: BorderRadius.circular(32),
);

// border for all 3 colors
final kGradientBoxDecoration = BoxDecoration(
  gradient: LinearGradient(
      colors: [Colors.yellow.shade600, Colors.orange, Colors.red]),
  border: Border.all(
    color: Colors.amber, //kHintColor, so this should be changed?
  ),
  borderRadius: BorderRadius.circular(32),
);
