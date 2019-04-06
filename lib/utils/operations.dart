import 'dart:async';

import 'package:flutter/material.dart';
import 'package:namma_chennai/model/apps.dart';
import 'package:namma_chennai/model/user.dart';
import 'package:namma_chennai/model/userapps.dart';
import 'package:namma_chennai/utils/globals.dart';

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
                  title: Text(app.appName["en"]),
                  subtitle: InkWell(
                    child: Text(app.appLaunchDate),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: ListTile(
                    subtitle: Text(app.appDesc["en"]),
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
                                  'Install',
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
}
