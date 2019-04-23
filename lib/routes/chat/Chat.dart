import 'package:flutter/material.dart';
import 'chatscreen.dart';

class Chat extends StatefulWidget{
  @override
  ChatState createState()=> new ChatState();

}

class ChatState extends State<Chat>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Namma Chennai Chat"),
        ),
        body: new ChatScreen()
    );
  }
}