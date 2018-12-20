import 'package:flutter/material.dart';
import 'package:namma_chennai/loader/color_loader.dart';
import 'package:namma_chennai/loader/dot_type.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    PlaceholderWidget(Colors.white),
    PlaceholderWidget(Colors.deepOrange),
    PlaceholderWidget(Colors.green)
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Namma Chennai'),
      ),
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('My Apps'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            title: Text('All Apps'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Profile'))
        ],
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: ColorLoader(
        dotOneColor: Colors.pink,
        dotTwoColor: Colors.amber,
        dotThreeColor: Colors.deepOrange,
        dotType: DotType.square,
        duration: Duration(milliseconds: 1200),
      ),
    );
  }
}
