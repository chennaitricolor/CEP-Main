import * as firebase from "firebase-admin";
import { QuerySnapshot, QueryDocumentSnapshot } from "@google-cloud/firestore";
import { Crypt } from "../auth/crypt";
const crypt = new Crypt();
export class User {
  getUser(userId) {
    return new Promise((resolve, reject) => {
      let data = null;
      var db = firebase.firestore();
      var userCollection = db
        .collection("users")
        .where("user_id", "==", userId);
      userCollection.get().then((result: QuerySnapshot) => {
        result.docs.forEach((doc: QueryDocumentSnapshot) => {
          data = doc.data();
        });
        resolve(data);
      });
    });
  }

  verifyAndUpdate(userId) {
    console.log("Verify and Update for -> " + userId);
    return new Promise((resolve, reject) => {
      let appKey = null;
      let data = {};
      var db = firebase.firestore();
      var userCollection = db
        .collection("users")
        .where("user_id", "==", userId);
      userCollection.get().then((result: QuerySnapshot) => {
        result.docs.forEach((doc: QueryDocumentSnapshot) => {
          console.log("Existence " + doc.exists);
          if (!doc.exists) {
            resolve({ message: "USER_NOT_FOUND" });
          } else {
            data = doc.data();
            appKey = data["app_key"];
            console.log("So, App key is " + appKey);
            if (appKey) {
              // If appkey exists, check for app_key validity
              if (crypt.isTokenValid(appKey)) {
                // If time diff is beyond 24 hours, regenerate the token
                let newKey = crypt.generateAppKey(userId);
                this.updateAppKey(db, doc, newKey).then(r => {
                  resolve({ data, newKey, message: "VERIFIED_AND_UPDATED" });
                });
              } else {
                resolve({ data, appKey, message: "VERIFIED" });
              }
            } else {
              let newKey = crypt.generateAppKey(userId);
              this.updateAppKey(db, doc, newKey).then(r => {
                resolve({ data, newKey, message: "VERFIED_AND_CREATED" });
              });
            }
          }
        });
      });
    });
  }

  updateAppKey(db, doc, newKey) {
    console.log("Update app key " + newKey);
    return db
      .collection("users")
      .doc(doc.id)
      .update({ app_key: newKey });
  }
}
