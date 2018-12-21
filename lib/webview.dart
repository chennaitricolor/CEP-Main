import 'package:flutter/material.dart';

class WebViewScreen extends StatefulWidget {
  @override
  _WebViewScreenState createState() => new _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Third Party App View'),
      ),
      // body: _children[_currentIndex], // new
    );
  }
}