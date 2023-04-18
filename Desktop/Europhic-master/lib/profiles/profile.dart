import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialmedia/Authentication/splash.dart';
import 'package:socialmedia/FlatBtn.dart';
import 'package:socialmedia/FollowersAndFollowing/Followers.dart';
import 'package:socialmedia/FollowersAndFollowing/Following.dart';
import 'package:socialmedia/chats/ViewImage.dart';
import 'package:socialmedia/settings/theme.dart';

class profile extends StatefulWidget {
  // const profile({ Key? key }) : super(key: key);

  @override
  _profileState createState() => _profileState();
}

var imageurl;

class _profileState extends State<profile> {
  Color theme_main;
  Color theme_text;
  Color theme_icon;
  ScrollController _arrowsController = ScrollController();
  var email;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool a = true;
  var followercount = 0;
  var followingcount = 0;
  var postcount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFollowersFollowing();
    App_theme();
  }

  getFollowersFollowing() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
    });
    print(email);

    var qsnap = await FirebaseFirestore.instance
        .collection('Followers')
        .doc(email)
        .collection('followers')
        .get();
    followercount = qsnap.docs.length;
    print(email);
    print(followercount);
    var qsnap2 = await FirebaseFirestore.instance
        .collection('Following')
        .doc(email)
        .collection('following')
        .get();
    followingcount = qsnap2.docs.length;
    print(followingcount);
    var qsnap3 = await FirebaseFirestore.instance
        .collection('Post')
        .where('email', isEqualTo: email)
        .get();
    postcount = qsnap3.docs.length;
    print(postcount);
    print(followingcount);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('users').doc(email).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: theme_main,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          var dc = snapshot.data;
          return Scaffold(
            backgroundColor: theme_main,
            // drawer: drawer,
            endDrawer: Drawer(
              elevation: 10.0,
              child: ListView(
                children: <Widget>[
                  //Here you place your menu items
                  Container(
                    color: theme_icon,
                    child: Column(
                      children: [
                        ListTile(
                          // leading: Icon(Icons.home),
                          title: Text(dc['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: theme_main,
                              )),
                          onTap: () {
                            // Here you can give your route to navigate
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.info,
                            color: theme_main,
                          ),
                          title: Text('About',
                              style: TextStyle(
                                fontSize: 18,
                                color: theme_main,
                              )),
                          onTap: () {
                            //code
                          },
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            height: 3.0,
                            thickness: 0.1,
                            color: Colors.grey[500],
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.lock,
                            color: theme_main,
                          ),
                          title: Text('Privacy',
                              style: TextStyle(
                                fontSize: 18,
                                color: theme_main,
                              )),
                          onTap: () {
                            //code
                          },
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            height: 3.0,
                            thickness: 0.1,
                            color: Colors.grey[500],
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.help,
                            color: theme_main,
                          ),
                          title: Text('Help',
                              style: TextStyle(
                                fontSize: 18,
                                color: theme_main,
                              )),
                          onTap: () {
                            //code
                          },
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            height: 3.0,
                            thickness: 0.1,
                            color: Colors.grey[500],
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.color_lens,
                            color: theme_main,
                          ),
                          title: Text('Theme',
                              style: TextStyle(
                                fontSize: 18,
                                color: theme_main,
                              )),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => theme()));
                            //code
                          },
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            height: 3.0,
                            thickness: 0.1,
                            color: Colors.grey[500],
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.logout_rounded,
                            color: theme_main,
                          ),
                          title: Text('Logout',
                              style: TextStyle(
                                fontSize: 18,
                                color: theme_main,
                              )),
                          onTap: () {
                            //code
                            DialogBoxLogOut(context);
                          },
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            height: 3.0,
                            thickness: 0.1,
                            color: Colors.grey[500],
                          ),
                        ),
                        Container(
                          height: 1800,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            key: scaffoldKey,
            appBar: AppBar(
              toolbarHeight: 60,
              backgroundColor: theme_main,
              elevation: 0,
              leading: Icon(
                Icons.arrow_back_ios_new_outlined,
                size: 22,
                color: theme_icon,
              ),
              title: Text(
                dc['name'],
                style: TextStyle(
                    color: theme_text,
                    fontSize: 22,
                    fontWeight: FontWeight.w800),
              ),
              actions: [
                GestureDetector(
                  onTap: () => scaffoldKey.currentState.openEndDrawer(),
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.keyboard_control_rounded,
                      size: 30,
                      color: theme_icon,
                    ),
                  ),
                ),
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
                              border:
                                  Border.all(width: 2, color: Colors.grey[300]),
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
                                    image: NetworkImage(dc['photo']))),
                          ),
                        )
                      ],
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          dc['name'],
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Following()));
                            },
                            child: Column(
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
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Followers()));
                            },
                            child: Column(
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
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                    '$postcount',
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
                            ),
                          )
                        ],
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            width: 150,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.blue,
                            ),
                            child: Center(
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    letterSpacing: 0.8,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              DialogBoxImage(context);
                            },
                            child: Container(
                                margin: EdgeInsets.only(top: 20),
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                    color: theme_text,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    )),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 25,
                                  color: theme_main,
                                )),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: EdgeInsets.only(left: 30, top: 35),
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
                                  right: 20, top: 30, bottom: 20),
                              child: Icon(
                                Icons.more_vert,
                                color: theme_icon,
                              )),
                        )
                      ],
                    ),
                    // Container(
                    //   height: 270,
                    //   padding: EdgeInsets.all(8),
                    // child:
                    // GridView.builder(
                    //     shrinkWrap: true,
                    //     physics: ScrollPhysics(),
                    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //         crossAxisCount: 3,
                    //         childAspectRatio: 5 / 5,
                    //         crossAxisSpacing: 8,
                    //         mainAxisSpacing: 8),
                    //     itemCount: postcount,
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
                    //     }),
                    // ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Post')
                          .where('email', isEqualTo: email)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: const Text('Loading events...'));
                        }

                        return Container(
                          margin: EdgeInsets.only(top: 0),
                          width: MediaQuery.of(context).size.width,
                          height: 364,
                          decoration: BoxDecoration(
                            color: a ? Colors.grey[900] : Colors.white,
                          ),
                          child: Container(
                            height: double.infinity,
                            margin: EdgeInsets.only(bottom: 1, top: 1),
                            width: double.infinity,
                            child: GridView.builder(
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, i) {
                                var doc = snapshot.data.docs[i]['image'];
                                var doctext = snapshot.data.docs[i]['text'];
                                var docemail = snapshot.data.docs[i]['email'];
                                var docid = snapshot.data.docs[i].id;
                                print("$docid");
                                return Container(
                                    child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 5, right: 5, top: 1),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onLongPress: () {
                                            DialogBoxDelete(context, docid);
                                          },
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewImage(doc)));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Container(
                                              height: 119,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: snapshot.data.docs[i]
                                                                  ['image'] ==
                                                              "" ||
                                                          snapshot.data.docs[i]
                                                                  ['image'] ==
                                                              null
                                                      ? AssetImage(
                                                          'assets/images/EU.png')
                                                      : NetworkImage(doc),
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
                              itemCount: postcount,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
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
        FlatButtonC(
          color: Colors.black,
          child: new Text("Yes", style: TextStyle(color: Colors.white)),
          onPressed: () async {
            FirebaseFirestore.instance.collection('Post').doc(id).delete();
            setState(() {
              postcount = postcount - 1;
            });
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  void DialogBoxImage(context) {
    var baseDialog = AlertDialog(
      title: new Text(
        "Upload Profile Picture",
        // style: txt.andika,
      ),
      content: Container(
        child: Text(
          'Change Profile picture ',
          // style: txt.andikasmall,
        ),
      ),
      actions: <Widget>[
        FlatButtonC(
          color: Colors.black,
          child: new Text("Yes", style: TextStyle(color: Colors.white)),
          onPressed: () async {
            uploadImage();
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  uploadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    print('This Code Will Run');
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);
      if (image != null) {
        var snapshot = await _storage
            .ref()
            .child('UserProfilePhoto')
            .child(email)
            .child(generateRandomString(200))
            .putFile(file);

        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageurl = downloadUrl;
        });
        FirebaseFirestore.instance.collection('users').doc(email).update({
          'photo': imageurl,
        });
        print(imageurl);
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  void DialogBoxLogOut(context) {
    var baseDialog = AlertDialog(
      title: new Text(
        "Logout",
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Container(
        child: Text('Are you sure you want to logout?'),
      ),
      actions: <Widget>[
        FlatButtonC(
          color: theme_main,
          child: new Text(
            "Yes",
            style: TextStyle(color: theme_text, fontSize: 16),
          ),
          onPressed: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            await pref.clear();
            // FirebaseAuth.instance.signOut();
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SplashScreen()));
            // SystemNavigator.pop();
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  App_theme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('name', nameCont.text);
    // prefs.setString('username', usernameCont.text);
    setState(() {
      email = prefs.getString('email');
      print(email);
      a = prefs.getBool('theme');
    });
    getFollowersFollowing();
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
