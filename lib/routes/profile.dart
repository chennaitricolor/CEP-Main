import 'package:flutter/material.dart';
import 'package:namma_chennai/loader/color_loader.dart';
import 'package:namma_chennai/loader/dot_type.dart';

class ProfileScreen extends StatelessWidget {
  final Color color;

  ProfileScreen(this.color);

  @override
  Widget build(BuildContext context) {
    showNGOForm() {
      showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return new Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new ListTile(
                  title: Text("NGO Registration"),
                ),
                Container(
                  // margin: EdgeInsets.only(left: 10),
                  child: Column(
                    children: <Widget>[
                      new Container(
                        width: MediaQuery.of(context).size.width - 50,
                        child: new TextField(
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.send,
                            decoration: InputDecoration(
                              labelText: "Name",
                              hasFloatingPlaceholder: true,
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.teal)),
                            ),
                            autofocus: true),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width - 50,
                        child: new TextField(
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.send,
                            decoration: InputDecoration(
                              labelText: "Email",
                              hasFloatingPlaceholder: true,
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.teal)),
                            ),
                            autofocus: true),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  margin: EdgeInsets.only(left: 10),
                  child: FlatButton(
                    color: Colors.red,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 58.0),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            );
          });
    }

    return new Scaffold(
        backgroundColor: Colors.black12,
        appBar: new AppBar(
          backgroundColor: Colors.redAccent,
          elevation: 0,
          centerTitle: false,
          title: new Text('Profile'),
        ),
        body: new Stack(
          children: <Widget>[
            // The containers in the background
            new Column(
              children: <Widget>[
                new Container(
                  height: MediaQuery.of(context).size.height * .2,
                  color: Colors.redAccent,
                ),
              ],
            ),
            // The card widget with top padding,
            // incase if you wanted bottom padding to work,
            // set the `alignment` of container to Alignment.bottomCenter
            new Container(
              alignment: Alignment.topCenter,
              padding: new EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .01,
                  right: 10.0,
                  left: 10.0),
              child: new Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      new Card(
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
                                  new SliverGridDelegateWithFixedCrossAxisCount(
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
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("Change $index")
                                    ],
                                  ),
                                );
                              }),
                        ),
                        height: 230,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      FlatButton(
                        color: Colors.red,
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/start', (_) => false);
                          // Navigator.pushNamedAndRemoveUntil(
                          //     context, '/dashboard', (_) => false);
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 150.0),
                          child: Text(
                            'Logout',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
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
