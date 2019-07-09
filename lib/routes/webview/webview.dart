import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewScreen extends StatefulWidget {
  String url;
  String name;
  WebViewScreen({this.url, this.name});

  @override
  _WebViewScreenState createState() =>
      new _WebViewScreenState(appUrl: this.url, name: this.name);
}

class _WebViewScreenState extends State<WebViewScreen> {
  String appUrl;
  String name;

  _WebViewScreenState({this.appUrl, this.name});

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: this.appUrl,
      appBar: AppBar(
        title: Text(this.name),
      ),
      withZoom: false,
      clearCache: false,
      initialChild: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: new CircularProgressIndicator(),
        ),
      ),
      withJavascript: true,
      withLocalStorage: true,
      appCacheEnabled: true,
      hidden: false,
    );
  }
}