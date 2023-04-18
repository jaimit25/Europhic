import 'package:flutter/material.dart';
import 'package:socialmedia/chats/Chatlist.dart';
import 'package:socialmedia/chats/friends.dart';
import 'package:socialmedia/chats/group.dart';

class tabbase extends StatelessWidget {
  final String tabName;

  tabbase({@required this.tabName});

  @override
  Widget build(BuildContext context) {
    Tabs_Controller(String tabs) {
      switch (tabs) {
        case "Chatlist":
          return Chatlist();
          break;
        case "Friends":
          return friends();
          break;
        case "groups":
          return groups();
          break;
      }
    }

    Size size = MediaQuery.of(context).size;
    return Tabs_Controller(this.tabName);
  }
}
