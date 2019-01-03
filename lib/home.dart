import 'package:flutter/material.dart';
import 'package:namma_chennai/routes/myapps.dart';
import 'package:namma_chennai/routes/search.dart';
import 'package:namma_chennai/routes/allapps.dart';
import 'package:namma_chennai/routes/profile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    MyAppScreen(),
    SearchScreen(Colors.grey),
    AllAppsScreen(Colors.deepOrange),
    ProfileScreen(Colors.green)
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: new AppBar(
      //   title: new Text('Namma Chennai'),
      // ),
      // body: _children[_currentIndex], // new
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('My Apps'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            title: Text('All Apps'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Profile'))
        ],
      ),
    );
  }
}
// ButtonTheme.bar(
//   // make buttons use the appropriate styles for cards
//   child: ButtonBar(
//     children: <Widget>[
//       FlatButton(
//         child: const Text('UNINSTALL'),
//         onPressed: () {/* ... */},
//       ),
//       FlatButton(
//         child: const Text('INSTALL'),
//         onPressed: () {/* ... */},
//       ),
//     ],
//   ),
// ),
