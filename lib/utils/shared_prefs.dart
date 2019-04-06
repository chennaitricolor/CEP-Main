import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

const String _storageKey = "NC_";
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
class SharedPrefs {

   /// ----------------------------------------------------------
  /// Generic routine to fetch an application preference
  /// ----------------------------------------------------------
  Future<String> getApplicationSavedInformation(String name) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString(_storageKey + name) ?? '';
  }

  /// ----------------------------------------------------------
  /// Generic routine to saves an application preference
  /// ----------------------------------------------------------
  Future<bool> setApplicationSavedInformation(String name, String value) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString(_storageKey + name, value);
  }

  /// ----------------------------------------------------------
  /// Generic routine to remove an application preference
  /// ----------------------------------------------------------
  Future<bool> removeApplicationSavedInformation(String name) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.remove(_storageKey + name);
  }
}