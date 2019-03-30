import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:namma_chennai/locale/all_translations.dart';
import 'package:namma_chennai/routes/walkthrough/walkthrough.dart';
import 'package:namma_chennai/routes/splash/splash.dart';
import 'package:namma_chennai/routes/auth/auth.dart';
import 'package:namma_chennai/routes/form/userform.dart';
import 'package:namma_chennai/routes/dashboard/home.dart';
import 'package:namma_chennai/routes/appdetail/appdetail.dart';
import 'package:namma_chennai/routes/language/language.dart';
import 'package:namma_chennai/routes/webview/webview.dart';
import 'package:namma_chennai/routes/form/ngoform.dart';
import 'package:namma_chennai/routes/form/location.dart';
import 'package:namma_chennai/utils/shared_prefs.dart';

final SharedPrefs _sharedPrefs = new SharedPrefs();

void main() async {
  // Initializes the translation module
  await allTranslations.init();

  // then start the application
  runApp(
      // MyApp(),
      NammaApp());
}

class NammaApp extends StatefulWidget {
  @override
  _NammaAppState createState() => _NammaAppState();
}

class _NammaAppState extends State<NammaApp> {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    // Initializes a callback should something need
    // to be done when the language is changed
    allTranslations.onLocaleChangedCallback = _onLocaleChanged;

    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print("onMessage");
      print(message);
    }, onResume: (Map<String, dynamic> message) {
      print("onResume");
      print(message);
    }, onLaunch: (Map<String, dynamic> message) {
      print("onLaunch");
      print(message);
    });
    _firebaseMessaging.getToken().then((token) {
      print("====================");
      print(token);
      // _share
    _sharedPrefs.setApplicationSavedInformation("messageToken", token);
      print("====================");
    });

    _firebaseMessaging.setAutoInitEnabled(true);
  }

  ///
  /// If there is anything special to do when the user changes the language
  ///
  _onLocaleChanged() async {
    // do anything you need to do if the language changes
    print('Language has been changed to: ${allTranslations.currentLanguage}');
    // allTranslations.setPreferredLanguage(allTranslations.currentLanguage);
  }

  ///
  /// Main initialization
  ///
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // Tells the system which are the supported languages
      supportedLocales: allTranslations.supportedLocales(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Raleway', primarySwatch: Colors.blue),
      initialRoute: '/start',
      home: new Auth(),
      routes: <String, WidgetBuilder>{
        '/start': (BuildContext context) => new Splash(),
        '/language': (BuildContext context) => new LanguagePreferences(),
        '/auth': (BuildContext context) => new Auth(),
        '/form': (BuildContext context) => new UserForm(),
        '/home': (BuildContext context) => new Home(),
        '/appdetail': (BuildContext context) => new AppDetailScreen(),
        '/appview': (BuildContext context) => new WebViewScreen(),
        '/ngoform': (BuildContext context) => new NGOForm(),
      },
    );
  }
}
