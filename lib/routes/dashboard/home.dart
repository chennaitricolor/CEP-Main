import 'package:flutter/material.dart';
import 'package:namma_chennai/locale/all_translations.dart';
import 'package:namma_chennai/routes/dashboard/allapps.dart';
import 'package:namma_chennai/routes/dashboard/myapps.dart';
import 'package:namma_chennai/routes/dashboard/profile.dart';
import 'package:namma_chennai/routes/dashboard/search.dart';
import 'package:namma_chennai/routes/chat/chat.dart';

import 'package:namma_chennai/utils/globals.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  int currentIndex = 0;
  final List<Widget> children = [
    MyApps(),
    Search(),
    Chat(),
    AllApps(),
    Profile()
  ];

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        key: globalKey,
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: currentIndex,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(allTranslations.text('translation_14')),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text(allTranslations.text('translation_15')),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('Chat'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            title: Text(allTranslations.text('translation_16')),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text(allTranslations.text('translation_17')),
          ),
        ],
      ),
    );
  }
}