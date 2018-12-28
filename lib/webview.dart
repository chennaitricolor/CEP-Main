import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:namma_chennai/loader/color_loader.dart';
import 'package:namma_chennai/loader/dot_type.dart';

class WebViewScreen extends StatefulWidget {
  String url;
  WebViewScreen({this.url});

  @override
  _WebViewScreenState createState() =>
      new _WebViewScreenState(appUrl: this.url);
}

class _WebViewScreenState extends State<WebViewScreen> {
  String appUrl;

  _WebViewScreenState({this.appUrl});

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: this.appUrl,
      appBar: AppBar(
        title: const Text('My App'),
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
