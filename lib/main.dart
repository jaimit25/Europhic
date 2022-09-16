import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socialmedia/Authentication/splash.dart';
import 'package:socialmedia/Tabs/VideoPlayer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      // home: VideoPlayer(),
    );
  }
}
