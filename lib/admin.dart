import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/Tabs/home.dart';
import 'package:video_player/video_player.dart';

import 'Tabs/VideoItem.dart';

class Admin extends StatefulWidget {
  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("Post").snapshots(),
                builder: (c, snap) {
                  return snap.hasData
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: snap.data.docs.length,
                          itemBuilder: (c, i) {
                            // return Tile(
                            //   comments: snap.data.docs[i]["comments"],
                            //   email: snap.data.docs.email[i]["email"],
                            //   DateTime: snap.data.docs[i]["DateTime"],
                            //   type: snap.data.docs[i]["type"],
                            //   text: snap.data.docs[i]["text"],
                            //   image: snap.data.docs[i]["image"],
                            //   userPhoto: snap.data.docs[i]["userPhoto"],
                            //   name: snap.data.docs[i]["name"],
                            //   checkvideo: snap.data.docs[i]["checkvideo"],
                            //   video: snap.data.docs[i]["video"],
                            // );
                            return Container(
                              // height: 560,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.black,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: NetworkImage(snap
                                                  .data.docs[i]["userPhoto"]),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snap.data.docs[i]["name"],
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 10, left: 10, bottom: 10),
                                    width: 300,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      snap.data.docs[i]["text"],
                                      // textAlign: TextAlign.left,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  snap.data.docs[i]["checkvideo"]
                                      ? VideoItems(
                                          videoPlayerController:
                                              VideoPlayerController.network(
                                                  snap.data.docs[i]["video"]),
                                          looping: true,
                                          autoplay: true,
                                        )
                                      : Container(
                                          height: 400,
                                          decoration: BoxDecoration(
                                            // shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  snap.data.docs[i]["image"]),
                                            ),
                                          ),
                                        ),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 1,
                                          color: true
                                              ? Colors.grey[900]
                                              : Colors.grey[300],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(50),
                                            ),
                                          ),
                                          child: InkWell(
                                            onTap: () async {
                                              FirebaseFirestore.instance
                                                  .collection("Post")
                                                  .doc(snap.data.docs[i].id)
                                                  .delete();
                                            },
                                            child: Center(
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
                      : SizedBox();
                }),
          )
        ],
      )),
    );
  }
}
