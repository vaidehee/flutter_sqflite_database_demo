import 'package:flutter/material.dart';
import 'UiScreens/NoteList.dart';
import 'UiScreens/NoteDetails.dart';

void main()
{
  runApp(MyApp());
}
class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "Simply Notes",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen
      ),
      home: NoteList(),
    );
  }

}