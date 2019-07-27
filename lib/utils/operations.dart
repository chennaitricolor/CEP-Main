import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_chennai/locale/all_translations.dart';
import 'package:hello_chennai/model/apps.dart';
import 'package:hello_chennai/model/user.dart';
import 'package:hello_chennai/model/userapps.dart';
import 'package:hello_chennai/utils/globals.dart';

class Operations {
  Future installApp(UserApps userApps, Apps selectedApp, String userId,
      String documentId, BuildContext context) {
    popupWidget.showLoading(context, "Installing");
    Completer completer = new Completer();
    if (userApps == null) {
      userApps = new UserApps(userId);
      userApps.apps = new List();
      userApps.layout = new List();
    }
    if (userApps.apps.length > 0) {
      userApps.apps.add(selectedApp.appId);
      userApps.layout.add(selectedApp.appId);
      fireCollections
          .updateUserAppsByDocumentId(documentId, userApps)
          .then((r) {
        popupWidget.hideLoading(context);
        return completer.complete("UPDATED");
      }).catchError((e) {
        popupWidget.show(context, e);
      });
    } else {
      userApps.apps.add(selectedApp.appId);
      userApps.layout.add(selectedApp.appId);
      fireCollections.assignUserAppToUserId(userApps).then((r) {
        popupWidget.hideLoading(context);
        return completer.complete("CREATED");
      }).catchError((e) {
        popupWidget.hideLoading(context);
        popupWidget.show(context, e);
      });
    }
    return completer.future;
  }

  Future removeApp(UserApps userApps, Apps selectedApp, String documentId,
      BuildContext context) {
    popupWidget.showLoading(context, "Removing");
    List<String> updatedList = [];
    Completer completer = new Completer();
    userApps.apps.forEach((id) {
      if (selectedApp.appId != id) {
        updatedList.add(id);
      }
    });
    userApps.apps = updatedList;
    fireCollections.updateUserAppsByDocumentId(documentId, userApps).then((r) {
      popupWidget.hideLoading(context);
      return completer.complete("REMOVED");
    }).catchError((e) {
      popupWidget.hideLoading(context);
      popupWidget.show(context, e);
    });
    return completer.future;
  }

  Future showAppSelection(UserApps userApps, Apps app, String userId,
      String documentId, BuildContext context) {
    Completer completer = new Completer();
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                ListTile(
                  leading: Image(
                    image: AssetImage(app.appIconUrl),
                    width: 60.0,
                  ),
                  // Image.network(
                  //   app["appIconUrl"],
                  //   width: 50,
                  // ),
                  title: Text(app.appName[languageCode]),
                  subtitle: InkWell(
                    child: Text(app.appLaunchDate),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: ListTile(
                    subtitle: Text(app.appDesc[languageCode]),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 20,
                  child: (userApps != null && userApps.apps.contains(app.appId))
                      ? FlatButton(
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          onPressed: () {
                            operations
                                .removeApp(userApps, app, documentId, context)
                                .then((r) {
                              return completer.complete("REMOVED");
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 0.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Remove',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        )
                      : FlatButton(
                          color: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          onPressed: () {
                            operations
                                .installApp(
                                    userApps, app, userId, documentId, context)
                                .then((result) {
                              return completer.complete("INSTALLED");
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 0.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  allTranslations.text('translation_41'),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'This will add to your home screen',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.all(40),
                ),
              ],
            ),
          );
        });
    return completer.future;
  }

  Future<dynamic> showLanguageSelection(BuildContext context) {
    Completer completer = new Completer();
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  "Choose Language",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: 20.0, bottom: 20.0, left: 10, right: 10),
                    child: Column(
                      children: <Widget>[
                        FlatButton(
                          color: Color(0xFFDDDDDD),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          onPressed: () {
                            allTranslations.setNewLanguage("en").then((r) {
                              return completer.complete("en");
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'English',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        FlatButton(
                          color: Color(0xFFDDDDDD),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          onPressed: () {
                            allTranslations.setNewLanguage("ta").then((r) {
                              return completer.complete("ta");
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Tamil',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        FlatButton(
                          color: Color(0xFFDDDDDD),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          onPressed: () {
                            allTranslations.setNewLanguage("tn").then((r) {
                              return completer.complete("tn");
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Tanglish',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          );
        });
    return completer.future;
  }
}
