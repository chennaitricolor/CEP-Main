import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Widget> initSearchWidgets = [
    ListTile(
      title: Text("Recent Searches"),
    ),
    Column(
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
      ],
    )
  ];

  Widget searchCard() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.search),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Search apps"),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          centerTitle: false,
          title: Text('Search'),
        ),
        body: Column(children: <Widget>[
          Stack(children: <Widget>[
            Container(
              height: 80,
              color: Colors.blue,
            ),
            searchCard()
          ]),
          Container(
            child: Column(
              children: initSearchWidgets,
            ),
          )
        ]));
  }
}
