import 'package:flutter/material.dart';
import 'package:namma_chennai/loader/color_loader.dart';
import 'package:namma_chennai/loader/dot_type.dart';

class SearchScreen extends StatefulWidget {
  final Color color;

  SearchScreen(this.color);

  @override
  _SearchScreenState createState() => new _SearchScreenState(this.color);
}

class _SearchScreenState extends State<SearchScreen> {
  final Color color;
  bool _isRaw = true;
  List<Widget> _searchResults = <Widget>[];

  _SearchScreenState(this.color);

  @override
  Widget build(BuildContext context) {
    List<Widget> initSearchWidgets = [
      ListTile(
        title: Text("Trending Searches"),
      ),
      Card(
          child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(Icons.trending_up),
              title: Text('Petta'),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(Icons.trending_up),
              title: Text('Viswasam'),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              leading: Icon(Icons.trending_up),
              title: Text('Sarkar'),
            ),
          ),
        ],
      ))
    ];

    return Scaffold(
        backgroundColor: Colors.black12,
        appBar: new AppBar(
          backgroundColor: Colors.redAccent,
          title: new TextField(
            // autofocus: true,
            onTap: () {},
            onChanged: (String searchTxt) {
              setState(() {
                if (searchTxt.length == 0) {
                  _isRaw = true;
                } else {
                  _isRaw = false;
                  _searchResults = [
                    ListTile(
                      title: Text("Search Result"),
                    ),
                    Card(
                        child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {},
                          child: ListTile(
                            leading: Icon(Icons.android),
                            title: Text(searchTxt),
                            subtitle: Text("TFC"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                          ),
                        ),
                      ],
                    ))
                  ];
                }
              });
            },
            style: new TextStyle(
              color: Colors.white,
            ),
            decoration: new InputDecoration(
                border: InputBorder.none,
                prefixIcon: new Icon(Icons.search, color: Colors.white),
                hintText: "Search",
                hintStyle: new TextStyle(color: Colors.white)),
          ),
        ),
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
            child: Container(
                child: Column(
                  children: _isRaw ? initSearchWidgets : _searchResults,
                ))));
  }
}

// ColorLoader(
//             dotOneColor: Colors.pink,
//             dotTwoColor: Colors.amber,
//             dotThreeColor: Colors.deepOrange,
//             dotType: DotType.circle,
//             duration: Duration(milliseconds: 1200),
//           ),
