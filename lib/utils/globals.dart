import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_chennai/locale/all_translations.dart';
import 'package:hello_chennai/utils/fire_collections.dart';
import 'package:hello_chennai/utils/operations.dart';
import 'package:hello_chennai/utils/popup_widget.dart';

FireCollections fireCollections = new FireCollections();
GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');
PopupWidget popupWidget = new PopupWidget();
Operations operations = new Operations();
StreamController<String> streamController = new StreamController.broadcast();
String languageCode = allTranslations.currentLanguage;