import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialmedia/Friends/Search.dart';

class request extends StatefulWidget {
  // const request({ Key? key }) : super(key: key);

  @override
  _requestState createState() => _requestState();
}

class _requestState extends State<request> {
  Color theme_main;
  Color theme_text;
  Color theme_icon;
  Color theme_navigation;
  var myemail;

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
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
        toolbarHeight: 45,
        backgroundColor: theme_main,
        elevation: 0,
        leading: Icon(
          Icons.arrow_back_ios_new_outlined,
          size: 22,
          color: theme_icon,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search()));
            },
            child: Container(
              margin: EdgeInsets.only(right: 30, top: 10),
              child: Container(
                // margin: EdgeInsets.only(top: 20),
                height: 35,
                width: 35,
                child: Icon(Icons.search_sharp, color: theme_icon),
                // decoration: BoxDecoration(
                //     borderRadius: BorderRadius.all(Radius.circular(200)),
                //     image: DecorationImage(
                //         fit: BoxFit.cover,
                //         image: NetworkImage(
                //             'https://i.pinimg.com/originals/6d/62/f0/6d62f0fb9edea6121981088f95ef5e53.jpg'))),
              ),
            ),
          ),
        ],
        centerTitle: true,
        leadingWidth: 70,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(left: 30, top: 20),
              child: Text(
                'Friend Request\'s',
                style: TextStyle(
                    color: theme_text,
                    fontSize: 30,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Divider(
              height: 3.0,
              thickness: 0.2,
              color: Colors.grey[500],
            ),
          ),
          Container(
            // height: 400,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Request')
                  .doc(myemail)
                  .collection('request')
                  .where('accepted', isEqualTo: 0)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data.docs.map<Widget>((document) {
                      return FriendList(document['photo'], document['username'],
                          document['name'], document['useremail']);
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget FriendList(
      String userimg, String username, String name, String useremail) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(5),
              height: 70,
              width: 70,
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
            GestureDetector(
              onTap: () {
                print(useremail);
                print(myemail);
                print("Rejected");
                FirebaseFirestore.instance
                    .collection('Request')
                    .doc(myemail)
                    .collection('request')
                    .doc(useremail)
                    .delete()
                    .then((value) {
                  print('Deleted Successfully');
                }).catchError((e) {
                  print('error deleting');
                });
                //   .then((value) {
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder:
                //             (BuildContext context) =>
                //                 super.widget));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.close,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Accepted");
                print(useremail);
                print(myemail);

                FirebaseFirestore.instance
                    .collection('Request')
                    .doc(myemail)
                    .collection('request')
                    .doc(useremail)
                    .update({'accepted': 1})
                    // .delete()
                    .then((value) {
                  FirebaseFirestore.instance
                      .collection('Followers')
                      .doc(myemail)
                      .collection('followers')
                      .doc(useremail)
                      .set({
                    'useremail': useremail,
                    'myemail': myemail,
                    'userimg': userimg,
                    'username': username,
                    'name': name,
                    // 'photo': userimg,
                    'useremail': useremail
                  }).then((value) async {
                    var collectionRef =
                        FirebaseFirestore.instance.collection('users');
                    var mydocu = await collectionRef.doc(myemail).get();
                    var mydata = mydocu.data();
                    FirebaseFirestore.instance
                        .collection('Following')
                        .doc(useremail)
                        .collection('following')
                        .doc(myemail)
                        .set({
                      'useremail': myemail,
                      'myemail': useremail,
                      'photo': mydata['photo'],
                      'username': mydata['username'],
                      'name': mydata['name'],
                      // 'photo': mydata['photo'],
                      'useremail': mydata['email'],
                    });
                  });
                }).catchError((e) {
                  print('error deleting');
                });
              },
              child: Container(
                margin: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.check,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  App_theme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // prefs.setString('name', nameCont.text);
    // prefs.setString('username', usernameCont.text);
    setState(() {
      myemail = prefs.getString('email');
      a = prefs.getBool('theme');
    });
    print(myemail + 'xxxxxbambxambxabxamb');
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
