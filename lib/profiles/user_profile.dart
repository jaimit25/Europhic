import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialmedia/FollowersAndFollowing/Followers.dart';
import 'package:socialmedia/chats/ChatScreen.dart';
import 'package:socialmedia/chats/ViewImage.dart';

class user_profile extends StatefulWidget {
  // const user_profile({ Key? key }) : super(key: key);
  var useremail;
  user_profile({@required this.useremail});
  @override
  _user_profileState createState() => _user_profileState(useremail: useremail);
}

class _user_profileState extends State<user_profile> {
  var useremail;
  _user_profileState({@required this.useremail});
  Color theme_main;
  Color theme_text;
  Color theme_icon;
  var myemail;

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  // bool a = false;
  bool a = true;
  bool check = false;
  var checkFollowers = false;
  var followercount = 0;
  var followingcount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFollowersFollowing();
    App_theme();
  }

  getFollowersFollowing() async {
    print(useremail);

    var qsnap = await FirebaseFirestore.instance
        .collection('Followers')
        .doc(useremail)
        .collection('followers')
        .get();
    followercount = qsnap.docs.length;
    print(useremail);
    print(followercount);
    print('xxxxxxxxxxxxxxxxxxxxx');
    var qsnap2 = await FirebaseFirestore.instance
        .collection('Following')
        .doc(useremail)
        .collection('following')
        .get();
    followingcount = qsnap2.docs.length;
    print(useremail);
    print(followingcount);
    print('xxxxxxxxxxxxxxxxxxxxx');
    setState(() {});
  }

  checkFollowersUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var myMail = prefs.getString('email');
    print(useremail);
    print(myMail);
    var checkdatafollowers = await FirebaseFirestore.instance
        .collection('Followers')
        .doc(useremail)
        .collection('followers')
        .doc(myMail)
        .get();
    setState(() {
      checkFollowers = checkdatafollowers.exists;
    });
    if (checkFollowers) {
      print('it exist ra');
    } else {
      print('it dosent exist ra');
    }
  }

  checkreq() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var myMail = prefs.getString('email');
    print(useremail);
    print(myMail);
    var mydata = await FirebaseFirestore.instance
        .collection('Request')
        .doc(useremail)
        .collection('request')
        .doc(myMail)
        .get();
    setState(() {
      check = mydata.exists;
    });
    if (check) {
      var dt = mydata.data();
      print(dt['name']);
      print(dt['email']);
      print(dt['photo']);
      print(dt['username']);
      print('data exist ');
      setState(() {
        check = true;
      });
    } else {
      print('data does not exist ');
      // var dt = mydata.data();
      // print(dt['name']);
      // print(dt['email']);
      // print(dt['photo']);
      // print(dt['username']);
      setState(() {
        check = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(useremail)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            var doc = snapshot.data;
            return Scaffold(
              backgroundColor: theme_main,
              key: scaffoldKey,
              appBar: AppBar(
                toolbarHeight: 60,
                backgroundColor: theme_main,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    size: 22,
                    color: theme_icon,
                  ),
                ),
                title: Text(
                  doc['name'],
                  style: TextStyle(
                      color: theme_text,
                      fontSize: 22,
                      fontWeight: FontWeight.w800),
                ),
                actions: [
                  // GestureDetector(
                  //   onTap: () => scaffoldKey.currentState.openEndDrawer(),
                  //   child: Container(
                  //     margin: EdgeInsets.only(right: 20),
                  //     child: Icon(
                  //       Icons.person_add,
                  //       size: 25,
                  //       color: theme_icon,
                  //     ),
                  //   ),
                  // ),
                ],
                centerTitle: true,
                leadingWidth: 70,
              ),
              body: Scrollbar(
                // isAlwaysShown: true,
                // thickness: 20,
                // radius: Radius.circular(50),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      // ListView(
                      Stack(
                        children: [
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 15),
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2, color: Colors.grey[300]),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(200)),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(200)),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(doc['photo']))),
                            ),
                          )
                        ],
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            doc['name'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: theme_text,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                    '$followingcount',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: theme_text,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    'Following',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                    '$followercount',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: theme_text,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    'Followers',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: Colors.grey[500]),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                    '25',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: theme_text,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    'Post',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: Colors.grey[500]),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            check
                                ? GestureDetector(
                                    onTap: () async {
                                      var collectionRef = FirebaseFirestore
                                          .instance
                                          .collection('users');
                                      var mydocu = await collectionRef
                                          .doc(myemail)
                                          .get();
                                      var mydata = mydocu.data();
                                      // var users = await collectionRef.doc(emailCont.text).snapshots();
                                      // bool check = mydocu.exists;
                                      FirebaseFirestore.instance
                                          .collection('Request')
                                          .doc(useremail)
                                          .collection('request')
                                          .doc(myemail)
                                          .delete()
                                          .then((value) {
                                        FirebaseFirestore.instance
                                            .collection('Following')
                                            .doc(myemail)
                                            .collection('following')
                                            .doc(useremail)
                                            .delete();
                                        FirebaseFirestore.instance
                                            .collection('Followers')
                                            .doc(useremail)
                                            .collection('followers')
                                            .doc(myemail)
                                            .delete()
                                            .then((value) async {
                                          print(
                                              'Followers Removed from user Account');
                                        }).then((value) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          super.widget));
                                        }).catchError((e) {
                                          print('error deleting task');
                                          print(e.toString());
                                        });
                                      });
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  super.widget));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 20),
                                      width: 120,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.red,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Remove',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              letterSpacing: 0.8,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      var collectionRef = FirebaseFirestore
                                          .instance
                                          .collection('users');
                                      var mydocu = await collectionRef
                                          .doc(myemail)
                                          .get();
                                      var mydata = mydocu.data();
                                      // var users = await collectionRef.doc(emailCont.text).snapshots();
                                      // bool check = mydocu.exists;
                                      FirebaseFirestore.instance
                                          .collection('Request')
                                          .doc(useremail)
                                          .collection('request')
                                          .doc(myemail)
                                          .set({
                                        'useremail': myemail,
                                        'email': myemail,
                                        'name': mydata['name'],
                                        'photo': mydata['photo'],
                                        'username': mydata['username'],
                                        'status': 0,
                                        'accepted': 0
                                      }).then((value) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        super.widget));
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 20),
                                      width: 120,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.blue,
                                      ),
                                      child: Center(
                                        child: Text(
                                          check ? 'Requested' : 'Follow',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              letterSpacing: 0.8,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 20),
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                    color: theme_text,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    )),
                                child: Icon(
                                  Icons.mail,
                                  size: 25,
                                  color: theme_main,
                                ))
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 50, left: 20, right: 20),
                          child: Divider(
                            height: 0.5,
                            thickness: 0.1,
                            color: theme_icon,
                          ),
                        ),
                      ),
                      checkFollowers
                          ? Container()
                          : Center(
                              child: Column(
                                children: [
                                  Center(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 20),
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                        color: Colors.grey[500],
                                      ),
                                      child: Icon(
                                        Icons.lock,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 15),
                                      child: Text(
                                        'This Account is Private',
                                        style: TextStyle(
                                          color: theme_text,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 40),
                                      margin: EdgeInsets.only(top: 12),
                                      child: Text(
                                        'Follow this Account to see their photos and videos.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                      checkFollowers
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 30, top: 35, bottom: 20),
                                    child: Text(
                                      'Photos',
                                      style: TextStyle(
                                        color: theme_text,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          right: 20, top: 35, bottom: 20),
                                      child: Icon(
                                        Icons.more_vert,
                                        color: theme_icon,
                                      )),
                                )
                              ],
                            )
                          : Container(),
                      // Container(
                      //   height: 300,
                      //   padding: EdgeInsets.all(8),
                      //   child:
                      checkFollowers
                          ? StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('Post')
                                  .where('email', isEqualTo: useremail)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: const Text('Loading events...'));
                                } else {
                                  return GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      //  snapshot.data.documents[index]['text'],
                                      return Container(
                                          child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 5, right: 5, top: 1),
                                          child: Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewImage(snapshot
                                                                          .data
                                                                          .documents[
                                                                      index]
                                                                  ['image'])));
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: Container(
                                                    height: 119,
                                                    width: 120,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: snapshot.data.documents[
                                                                            index][
                                                                        'image'] ==
                                                                    "" ||
                                                                snapshot.data.documents[
                                                                            index]
                                                                        [
                                                                        'image'] ==
                                                                    null
                                                            ? AssetImage(
                                                                'assets/images/EU.png')
                                                            : NetworkImage(snapshot
                                                                    .data
                                                                    .documents[
                                                                index]['image']),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                                    },
                                    itemCount: snapshot.data.docs.length,
                                  );
                                }
                              },
                            )

                          // GridView.builder(
                          //     physics: ScrollPhysics(),
                          //     shrinkWrap: true,
                          //     gridDelegate:
                          //         SliverGridDelegateWithFixedCrossAxisCount(
                          //             crossAxisCount: 3,
                          //             childAspectRatio: 3 / 4,
                          //             crossAxisSpacing: 8,
                          //             mainAxisSpacing: 8),
                          //     itemCount: 35,
                          //     itemBuilder: (BuildContext ctx, index) {
                          //       return Container(
                          //         alignment: Alignment.center,
                          //         decoration: BoxDecoration(
                          //             image: DecorationImage(
                          //                 fit: BoxFit.cover,
                          //                 image: NetworkImage(
                          //                     "https://i.pinimg.com/originals/6d/62/f0/6d62f0fb9edea6121981088f95ef5e53.jpg")),
                          //             borderRadius: BorderRadius.circular(15)),
                          //       );
                          //     })
                          : Container(),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void DialogBoxDelete(context, id) {
    var baseDialog = AlertDialog(
      title: new Text(
        "Delete",
        // style: txt.andika,
      ),
      content: Container(
        child: Text(
          'Delete Post',
          // style: txt.andikasmall,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          color: Colors.black,
          child: new Text("Yes", style: TextStyle(color: Colors.white)),
          onPressed: () async {
            FirebaseFirestore.instance.collection('Post').doc(id).delete();
            setState(() {
              // postcount = postcount - 1;
            });
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  App_theme() async {
    checkFollowersUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('name', nameCont.text);

    setState(() {
      myemail = prefs.getString('email');
      print(myemail);
      a = prefs.getBool('theme');
    });
    checkreq();

    if (a) {
      print("object");
      setState(() {
        theme_main = Colors.black;
        theme_text = Colors.white;
        theme_icon = Colors.white;
      });
    } else {
      setState(() {
        theme_main = Colors.white;
        theme_text = Colors.black;
        theme_icon = Colors.black;
      });
    }
  }
}
