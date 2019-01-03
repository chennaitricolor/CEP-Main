import 'package:flutter/material.dart';
import 'package:namma_chennai/loader/color_loader.dart';
import 'package:namma_chennai/loader/dot_type.dart';

class SearchScreen extends StatelessWidget {
  final Color color;

  SearchScreen(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: ColorLoader(
        dotOneColor: Colors.pink,
        dotTwoColor: Colors.amber,
        dotThreeColor: Colors.deepOrange,
        dotType: DotType.circle,
        duration: Duration(milliseconds: 1200),
      ),
    );
  }
}