import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_chennai/model/apps.dart';
import 'package:hello_chennai/model/orgs.dart';
import 'package:hello_chennai/model/user.dart';
import 'package:hello_chennai/model/userapps.dart';
import 'package:hello_chennai/utils/shared_prefs.dart';
import 'package:hello_chennai/utils/default_data.dart';

Firestore db = Firestore.instance;
CollectionReference userAppsCollection = db.collection('userapps');
CollectionReference usersCollection = db.collection('users');
CollectionReference orgsCollection = db.collection('orgs');
CollectionReference appsCollection = db.collection('apps');
SharedPrefs sharedPrefs = new SharedPrefs();

class FireCollections {
  /* Device Cache */

  Future getLoggedInUserId() {
    return sharedPrefs.getApplicationSavedInformation("loggedinuser");
  }

  Future setLoggedInUserId(String userId) {
    return sharedPrefs.setApplicationSavedInformation("loggedinuser", userId);
  }

  Future removeLoggedInUserId() {
    return sharedPrefs.removeApplicationSavedInformation("loggedinuser");
  }

  /* Apps Collection */

  // Create
  Future createApp(Apps app) {
    return appsCollection.document().setData(app.toJson());
  }

  // Update
  Future updateAppInfoByDocumentId(String documentId, Apps app) {
    return appsCollection.document(documentId).updateData(app.toJson());
  }

  // Delete
  Future deleteAppByDocumentId(String documentId) {
    return appsCollection.document(documentId).delete();
  }

  // Get
  Future<QuerySnapshot> getAllApps() {
    return appsCollection.getDocuments();
  }

  // Get by IDs
  Future<List<Apps>> getUserAppsByAppIds(List<String> ids) {
    print(ids);
    Completer completer = new Completer();
    List<Apps> installedApps = [];
    appsCollection.snapshots().forEach((QuerySnapshot result) {
      List<DocumentSnapshot> docs = result.documents;
      for (DocumentSnapshot doc in docs) {
        Apps app = new Apps.fromSnapShot(doc);
        if (ids.contains(app.appId)) {
          installedApps.add(app);
        }
      }
      return completer.complete(installedApps);
    });
    return completer.future;
  }

  /* Organization Collection */

  // Create
  Future assignUserOrgsByUserId(Orgs orgs) {
    return orgsCollection.document().setData(orgs.toJson());
  }

  // Get
  Future<QuerySnapshot> getUserOrgsByUserId(String userId) {
    return orgsCollection.where("user_id", isEqualTo: userId).getDocuments();
  }

  /* User Collection */

  // Create
  Future createUser(User user) {
    return usersCollection.document().setData(user.toJson());
  }

  // Update
  Future updateUserInfoByUserId(String documentId, User user) {
    return usersCollection.document(documentId).updateData(user.toJson());
  }

  // Get
  Future<QuerySnapshot> getUserInfoByUserId(userId) {
    return usersCollection.where("user_id", isEqualTo: userId).getDocuments();
  }

  /* User Apps Collection */

  // Create
  Future assignUserAppToUserId(UserApps userApps) {
    return userAppsCollection.document().setData(userApps.toJson());
  }

  // Update
  Future updateUserAppsByDocumentId(String documentId, UserApps userApps) {
    return userAppsCollection
        .document(documentId)
        .updateData(userApps.toJson());
  }

  // Get
  Future<QuerySnapshot> getUserAppsByUserId(userId) {
    return userAppsCollection
        .where("user_id", isEqualTo: userId)
        .getDocuments();
  }

  /* Exception Handler */

  showException(Exception e) {
    print(e);
  }
}
