import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello_chennai/locale/all_translations.dart';
import 'package:hello_chennai/model/user.dart';
import 'package:hello_chennai/routes/dashboard/allapps.dart';
import 'package:hello_chennai/routes/dashboard/myapps.dart';
import 'package:hello_chennai/routes/dashboard/profile.dart';
import 'package:hello_chennai/routes/chat/chatselection.dart';

import 'package:hello_chennai/utils/globals.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  int currentIndex = 0;
  var userId;
  static User currentUser;

void initState() {
    super.initState();
    fireCollections.getLoggedInUserId().then((val) {
      userId = val;
    }).then((r) {
      fireCollections
          .getUserInfoByUserId(userId)
          .then((QuerySnapshot snapshot) {
        List<DocumentSnapshot> docs = snapshot.documents;
        for (DocumentSnapshot doc in docs) {
          User user = new User.fromSnapShot(doc);
          currentUser = user;
        }
      });
    });
  }

  //Chat was removed as it was promoted to a seperate route
  final List<Widget> children = [
    MyApps(),
    AllApps(),
    null,
    Profile(),
    // Admin()
  ];

  void onTabTapped(int index) {
    switch(index){
      case 2:  Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatSelection(currentUser: currentUser,)),
      );
      break;
      default: setState(() {
        currentIndex = index;
      }); 

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        key: globalKey,
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: currentIndex,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(allTranslations.text('translation_14')),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            title: Text(allTranslations.text('translation_16')),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text(allTranslations.text('translation_44')),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text(allTranslations.text('translation_17')),
          ),
          // new BottomNavigationBarItem(
          //   icon: Icon(Icons.people),
          //   title: Text("Admin"),
          // ),
        ],
      ),
    );
  }
}
