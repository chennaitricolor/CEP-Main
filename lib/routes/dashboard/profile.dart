import 'package:flutter/material.dart';

class Profile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    showNGOForm() {
      // Navigator.pushNamed(context, "/ngo");
    }

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.black12,
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          elevation: 0,
          centerTitle: false,
          title: Text('Profile'),
        ),
        body: Stack(
          children: <Widget>[
            // The containers in the background
            Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * .2,
                  color: Colors.redAccent,
                ),
              ],
            ),
            // The card widget with top padding,
            // incase if you wanted bottom padding to work,
            // set the `alignment` of container to Alignment.bottomCenter
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .01,
                  right: 10.0,
                  left: 10.0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Card(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: ListTile(
                            title: Text(
                              "Hi, \nI am TechforCities v1.0",
                              style: TextStyle(fontSize: 20),
                            ),
                            trailing: Icon(
                              Icons.verified_user,
                              color: Colors.green,
                            ),
                            subtitle:
                                Text("tfchennai@google.com\nfrom Chennai"),
                          ),
                        ),
                        elevation: 4.0,
                      ),
                      Container(
                        child: Card(
                          child: GridView.builder(
                              itemCount: 6,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 2.4),
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return FlatButton(
                                  onPressed: () {
                                    showNGOForm();
                                  },
                                  color: Colors.white,
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    // Replace with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Icon(
                                        Icons.outlined_flag,
                                        size: 50,
                                      ),
                                      Text("Change $index")
                                    ],
                                  ),
                                );
                              }),
                        ),
                        height: 230,
                      ),
                      FlatButton(
                        color: Colors.red,
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/start', (_) => false);
                          // Navigator.pushNamedAndRemoveUntil(
                          //     context, '/dashboard', (_) => false);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 150.0),
                          child: Text(
                            'Logout',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ));
  }
}