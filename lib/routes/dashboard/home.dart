import 'package:flutter/material.dart';
import 'package:namma_chennai/routes/dashboard/allapps.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {

  int currentIndex = 0;
  final List<Widget> children = [
    // MyApps(),
    AllApps(),
    // Profile()
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
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: currentIndex,
        items: [
          // new BottomNavigationBarItem(
          //   icon: Icon(Icons.home),
          //   title: Text('My Apps'),
          // ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            title: Text('All Apps'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            title: Text('All Apps'),
          ),
          // new BottomNavigationBarItem(
          //     icon: Icon(Icons.person),
          //     title: Text('Profile'),
          // ),
        ],
      ),
    );
  }
}