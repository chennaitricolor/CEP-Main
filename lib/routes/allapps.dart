import 'package:flutter/material.dart';
import 'package:namma_chennai/loader/color_loader.dart';
import 'package:namma_chennai/loader/dot_type.dart';

class AllAppsScreen extends StatelessWidget {
  final Color color;

  AllAppsScreen(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        // Box decoration takes a gradient
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topLeft,
          end: Alignment.center,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0.5, 0.5],
          tileMode: TileMode.clamp,
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Colors.redAccent,
            Color(0xFFEEEEEE),
          ],
        ),
      ),
    );
  }
}