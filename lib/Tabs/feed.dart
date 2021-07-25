import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialmedia/Navigation.dart';

class Addfeed extends StatefulWidget {
  @override
  _AddfeedState createState() => _AddfeedState();
}

class _AddfeedState extends State<Addfeed> {
  Color theme_main;
  Color theme_text;
  Color theme_icon;
  Color theme_navigation;
  var email;

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  // bool a = false;
  bool a = true;
  var myLocation;
  double lat = 0, lng = 0;
  var Add = 'Address';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Timer timer = Timer.periodic(Duration(milliseconds: 900), (Timer t) {
    //   setState(() {});
    // });
    getUserLocation();
    App_theme();
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

  App_theme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // prefs.setString('username', usernameCont.text);
    setState(() {
      email = prefs.getString('email');
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

  var imageurl = '';

  TextEditingController _text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    onWillPop() {
      Navigator.of(context).pop();
    }

    // var provider = Provider.of<ProviderData>(context);
    return WillPopScope(
        child: Scaffold(
          backgroundColor: theme_main,
          appBar: AppBar(
            backgroundColor: theme_main,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (context) => Navigation()));
              },
              child: Icon(
                Icons.arrow_back,
                color: theme_icon,
              ),
            ),
            title: Text(
              'Post',
              style: TextStyle(
                color: theme_text,
              ),
            ),
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
                return FeedAddUI(
                  doc['username'],
                  doc['name'],
                  doc['email'],
                  doc['photo'],
                );
                // return FeedAddUI(doc['name'], doc['uid'], doc['email'],
                //     doc['Photo'], doc['classroom']);
              }
            },
          ),
          // body: FeedAddUI("Janavi_25", "Janavi Panchal", "uid", "email",
          //     "https://t3.ftcdn.net/jpg/01/41/81/30/360_F_141813016_vrZ4TFKphl7vLBty0kfQmIAEjFgtkJzW.jpg"),
        ),
        onWillPop: onWillPop);
  }

  FeedAddUI(username, name, email, Photo) {
    return ListView(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, top: 20),
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(Photo), fit: BoxFit.cover)),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: Text(
                    username,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme_text),
                  ),
                ),
                Container(
                  width: 200,
                  margin: EdgeInsets.only(left: 20, top: 5),
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500]),
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 5, left: 5),
          padding: EdgeInsets.all(10),
          height: 380,
          width: double.infinity,
          child: TextFormField(
            maxLines: 100,
            controller: _text,
            style: TextStyle(color: theme_text),
            decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 20),
                hintText: 'Write your Caption',
                border: InputBorder.none),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Wrap(
            children: [
              GestureDetector(
                onTap: () {
                  var temp;
                  setState(() {
                    temp = _text.text;
                    _text.text = temp + ' #Happy';
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text('#Happy'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  var temp;
                  setState(() {
                    temp = _text.text;
                    _text.text = temp + ' #Motivated';
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text('#Motivated'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  var temp;
                  setState(() {
                    temp = _text.text;
                    _text.text = temp + ' #Fun';
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text('#Fun'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  var temp;
                  setState(() {
                    temp = _text.text;
                    _text.text = temp + ' #Tech';
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text('#Tech'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  var temp;
                  setState(() {
                    temp = _text.text;
                    _text.text = temp + ' #Adventure';
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text('#Adventure'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  var temp;
                  setState(() {
                    temp = _text.text;
                    _text.text = temp + ' #Family';
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text('#Family'),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                uploadImage();
              },
              child: Container(
                padding: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(),
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: 30,
                  color: theme_icon,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // uploadImage();
                DialogBoxUpload(context, _text.text,
                    imageurl == null ? '' : imageurl, Photo, name);
              },
              child: Container(
                padding: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(),
                child: Icon(
                  Icons.send_outlined,
                  size: 30,
                  color: theme_icon,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  uploadImage() async {
    // imageurl = "";
    print('This Code Will Run');
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);
      if (image != null) {
        //Upload to Firebase
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String saveuid = prefs.getString('uid');
        var snapshot = await _storage
            .ref()
            .child('Post')
            .child(email)
            .child(generateRandomString(80))
            .putFile(file);

        var downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageurl = downloadUrl;
        });
        Fluttertoast.showToast(
            msg: 'Image Selected',
            timeInSecForIosWeb: 2,
            textColor: Colors.white,
            backgroundColor: Colors.black,
            gravity: ToastGravity.SNACKBAR);

        // DialogBoxImage(context);
        // FirebaseFirestore.instance.collection('Feeds')
        //     // .doc(saveuid)
        //     .add({'userPhoto': imageurl}).then((value) {
        //   Fluttertoast.showToast(
        //       msg: 'Image sent ',
        //       timeInSecForIosWeb: 2,
        //       textColor: Colors.white,
        //       backgroundColor: Colors.indigo[900],
        //       gravity: ToastGravity.BOTTOM);
        // }).catchError((e) {
        //   Fluttertoast.showToast(
        //       msg: 'Error selecting image',
        //       timeInSecForIosWeb: 2,
        //       textColor: Colors.white,
        //       backgroundColor: Colors.indigo[900],
        //       gravity: ToastGravity.BOTTOM);
        // });

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

  void DialogBoxUpload(context, value, imageurl, userPhoto, name) {
    var baseDialog = AlertDialog(
      title: new Text(
        "Share Post",
        // style: txt.andika,
      ),
      content: Container(
        child: Text(
          'Are you Sure you want to Upload?',
          // style: txt.andikasmall,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          color: Colors.indigo[900],
          child: new Text("Yes", style: TextStyle(color: Colors.white)),
          onPressed: () async {
            if (value == '' || value == null) {
              Fluttertoast.showToast(
                  msg: 'Text Cannot be Empty',
                  timeInSecForIosWeb: 2,
                  textColor: Colors.white,
                  backgroundColor: Color(0xff19196f),
                  gravity: ToastGravity.SNACKBAR);
            } else {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String saveuid = prefs.getString('uid');
              // String createRoom = getRoomId(saveuid, uuid);
              FirebaseFirestore.instance.collection('Post').doc(value).set({
                'text': value,
                'name': name,
                'image': imageurl == '' ? '' : imageurl,
                'email': email,
                'likes': 0,
                'track': 0,
                'comments': 0,
                'type': 'Feed',
                'extra': 'Extra',
                'userPhoto': userPhoto,
                ''
                    'DateTime': DateTime.now().toString(),
                'lat': lat == null ? 34.0479 : lat,
                'lng': lng == null ? 100.6197 : lng,
                'address': Add == null || Add == '' ? 'Address' : Add,
                'time': Timestamp.now().toString()
              }).then((value) {
                _text.text = '';
                print('Photo Uploaded');
                Fluttertoast.showToast(
                    msg: 'Post Shared ✅',
                    timeInSecForIosWeb: 2,
                    textColor: Colors.white,
                    backgroundColor: Colors.black,
                    gravity: ToastGravity.SNACKBAR);
              }).catchError((e) {
                Fluttertoast.showToast(
                    msg: 'Error Uploading Image',
                    timeInSecForIosWeb: 2,
                    textColor: Colors.white,
                    backgroundColor: Color(0xff19196f),
                    gravity: ToastGravity.SNACKBAR);
              });
            }

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
        "Upload Image",
        // style: txt.andika,
      ),
      content: Container(
        child: Text(
          'Enter Text and then Press Image Add Button to Enter Text. ',
          // style: txt.andikasmall,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          // color: color.theme1,
          child: new Text(
            "Yes",
            //  style: txt.lailaverysmall
          ),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String saveuid = prefs.getString('uid');
            // String createRoom = getRoomId(saveuid, uuid);
            FirebaseFirestore.instance.collection('users').doc(saveuid).update({
              'userPhoto': imageurl,
            }).then((value) {
              print('Photo Uploaded');
              Fluttertoast.showToast(
                  msg: 'Image Uploaded',
                  timeInSecForIosWeb: 2,
                  textColor: Colors.white,
                  backgroundColor: Color(0xff19196f),
                  gravity: ToastGravity.SNACKBAR);
            }).catchError((e) {
              Fluttertoast.showToast(
                  msg: 'Error Uploading Image',
                  timeInSecForIosWeb: 2,
                  textColor: Colors.white,
                  backgroundColor: Color(0xff19196f),
                  gravity: ToastGravity.SNACKBAR);
            });
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }
}
