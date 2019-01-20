import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:namma_chennai/locale/all_translations.dart';
import 'package:namma_chennai/routes/walkthrough/walkthrough.dart';
import 'package:namma_chennai/routes/auth/auth.dart';
import 'package:namma_chennai/routes/form/userform.dart';
import 'package:namma_chennai/routes/dashboard/home.dart';
import 'package:namma_chennai/routes/appdetail/appdetail.dart';
import 'package:namma_chennai/routes/language/language.dart';

void main() async {
  // Initializes the translation module
  await allTranslations.init();

  // then start the application
  runApp(
    NammaApp(),
  );
}

class NammaApp extends StatefulWidget {
  @override
  _NammaAppState createState() => _NammaAppState();
}

class _NammaAppState extends State<NammaApp> {
  @override
  void initState() {
    super.initState();

    // Initializes a callback should something need
    // to be done when the language is changed
    allTranslations.onLocaleChangedCallback = _onLocaleChanged;
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
      theme: ThemeData(fontFamily: 'Raleway', primarySwatch: Colors.red),
      initialRoute: '/start',
      home: new WalkThrough(),
      routes: <String, WidgetBuilder>{
        '/start': (BuildContext context) => new WalkThrough(),
        '/language': (BuildContext context) => new LanguagePreferences(),
        '/auth': (BuildContext context) => new Auth(),
        '/form': (BuildContext context) => new UserForm(),
        '/home': (BuildContext context) => new Home(),
        '/appdetail': (BuildContext context) => new AppDetailScreen(),
      },
    );
  }
}