const firebase = require("firebase-admin");
// const firestore = require("@google-cloud/firestore");
// import { QuerySnapshot, QueryDocumentSnapshot } from "@google-cloud/firestore";

function getUser(userId) {
  return new Promise((resolve, reject) => {
    let data = null;
    var db = firebase.firestore();
    var userCollection = db
      .collection("users")
      .where("user_id", "==", userId);
    userCollection
      .get()
      .then(result => {
        result.docs.forEach(doc => {
          data = doc.data();
        });
        resolve(data);
        return result;
      })
      .catch(err => {
        console.log(err);
      });
  });
}

function getUserByNumber(mobileNo) {
  return new Promise((resolve, reject) => {
    let data = null;
    var db = firebase.firestore();
    var userCollection = db
      .collection("users")
      .where("user_phone_number", "==", mobileNo);
    userCollection
      .get()
      .then(result => {
        result.docs.forEach(doc => {
          data = doc.data();
        });
        resolve(data);
        return result;
      })
      .catch(err => {
        console.log(err);
      });
  });
}

module.exports = {
  "getUserInfoByUserId" : getUser,
  "getUserByNumber" : getUserByNumber
}