import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:namma_chennai/loader/color_loader.dart';
import 'package:namma_chennai/loader/dot_type.dart';

class WebViewScreen extends StatefulWidget {
  @override
  _WebViewScreenState createState() => new _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: "https://www.swiggy.com",
      appBar: AppBar(
        title: const Text('Third party web view'),
      ),
      withZoom: false,
      clearCache: false,
      withJavascript: true,
      withLocalStorage: true,
      appCacheEnabled: true,
      hidden: false,
      initialChild: Container(
        child: ColorLoader(
          dotOneColor: Colors.pink,
          dotTwoColor: Colors.amber,
          dotThreeColor: Colors.deepOrange,
          dotType: DotType.circle,
          duration: Duration(milliseconds: 1200),
        ),
      ),
    );
  }
}
