import 'package:flutter/material.dart';
import 'package:namma_chennai/utils/default_data.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Map<String, String>> searchResult;
  List<Widget> searchResultWidget;
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    this.searchResult = DefaultData.apps;
    // getAllApps();
    buildSearchResultWidget();
  }

  buildSearchResultWidget() {
    this.searchResultWidget = [];
    searchResult.forEach((result) {
      if (result["appName"].toLowerCase().indexOf(searchTerm.toLowerCase()) >= 0 || searchTerm.isEmpty) {
        this.searchResultWidget.add(InkWell(
              onTap: () {},
              child: ListTile(
                leading: Icon(Icons.trending_up),
                title: Text(result["appName"]),
              ),
            ));
      }
    });
  }

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
                    onChanged: (value) {
                      setState(() {
                        searchTerm = value;
                      });
                      buildSearchResultWidget();
                    },
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
              children: <Widget>[
                ListTile(
                  title: Text(searchTerm.length == 0
                      ? "Recent Searches"
                      : "Search Result"),
                ),
                Column(children: searchResultWidget)
              ],
            ),
          )
        ]));
  }
}
