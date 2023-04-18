import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ViewImage extends StatefulWidget {
  String imgurl;
  ViewImage(@required this.imgurl);
  @override
  _ViewImageState createState() => _ViewImageState(imgurl);
}

class _ViewImageState extends State<ViewImage> {
  String imgurl;
  _ViewImageState(@required this.imgurl);
  int progress = 0;
  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort.send([id, status, progress]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");

    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });
      print(progress);
    });

    FlutterDownloader.registerCallback(downloadingCallback);
  }

  @override
  Widget build(BuildContext context) {
    onWillPop() {
      Navigator.of(context).pop();
    }

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              progress == -1 || progress == 0 ? 'Photo' : '$progress %',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            backgroundColor: Colors.black,
            actions: [
              // Text(imageurl.toString()),
              IconButton(
                icon: Icon(
                  Icons.download_rounded,
                  color: Colors.white,
                ),
                onPressed: () async {
                  final status = await Permission.storage.request();
                  if (status.isGranted) {
                    final externalDir = await getExternalStorageDirectory();

                    final id = await FlutterDownloader.enqueue(
                      url: imgurl.toString(),
                      savedDir: externalDir.path,
                      fileName: "Photo",
                      showNotification: true,
                      openFileFromNotification: true,
                    );
                  } else {
                    print("Permission deined");
                  }
                },
              ),
            ],
          ),
          backgroundColor: Colors.black,
          body: Center(
            child: GestureDetector(
              onTap: () async {
                final status = await Permission.storage.request();
                if (status.isGranted) {
                  final externalDir = await getExternalStorageDirectory();

                  final id = await FlutterDownloader.enqueue(
                    // url:
                    //     "https://firebasestorage.googleapis.com/v0/b/storage-3cff8.appspot.com/o/2020-05-29%2007-18-34.mp4?alt=media&token=841fffde-2b83-430c-87c3-2d2fd658fd41",
                    url: imgurl == null
                        ? Fluttertoast.showToast(
                            msg: "No Link Found",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.SNACKBAR,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0)
                        : imgurl.toString(),
                    savedDir: externalDir.path,
                    fileName: "Photo",
                    showNotification: true,
                    openFileFromNotification: true,
                  );
                } else {
                  print("Permission deined");
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 400,
                // child: Text(imgurl),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(imgurl),
                  ),
                ),
              ),
            ),
          ),
        ),
        onWillPop: onWillPop);
  }
}
