import 'package:flutter/material.dart';
import 'package:flutter_sqliite_database/Models/Note.dart';
import 'dart:async';
import 'package:flutter_sqliite_database/Models/Note.dart';
import 'package:flutter_sqliite_database/Utils/DataBaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class NoteDetails extends StatefulWidget {
  final String appBarTitle;
  Note note;

  NoteDetails(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteDetailsState(this.note, this.appBarTitle);
  }
}

class NoteDetailsState extends State<NoteDetails> {
  DataBaseHelper helper = DataBaseHelper();
  static var _priorities = ['High', 'Low'];
  String appBarTitle;
  Note note;

  TextEditingController titleTextEditController = new TextEditingController();
  TextEditingController discriptionTextEditController =
      new TextEditingController();

  NoteDetailsState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    titleTextEditController.text = note.title;
    discriptionTextEditController.text = note.description;

    // TODO: implement build
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  //on back button clicked
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                //First Element DropDown
                ListTile(
                  title: DropdownButton(
                      items: _priorities.map((String dropDownItems) {
                        return DropdownMenuItem<String>(
                          value: dropDownItems,
                          child: Text(dropDownItems),
                        );
                      }).toList(),
                      style: textStyle,
                      value: getPriorityAsString(note.priority),
                      onChanged: (valueSelectedByUser) {
                        setState(() {
                          debugPrint("User Selected $valueSelectedByUser");
                          updatePriorityAsInt(valueSelectedByUser);
                        });
                      }),
                ),

                //second element Title text Field
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleTextEditController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint("Title changed");
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                //Third Element Des Text field

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: discriptionTextEditController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint("Description changed");
                      updateDescrioption();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                //Forth Element Row(Two Buttons)
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      //Save Buttton
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save Button Clicked");
                              _save();
                            });
                          },
                        ),
                      ),

                      Container(
                        width: 5.0,
                      ),
                      //Delete Button
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save Button Clicked");
                              _delete();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  //convert string of priority to int for Database;
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  //int to string for displaying
// Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority;
  }

  //update title
  void updateTitle() {
    note.title = titleTextEditController.text;
  }

  //update description
  void updateDescrioption() {
    note.description = discriptionTextEditController.text;
  }

//save button click

  void _save() async {
    moveToLastScreen(); //after updating go to previous
    note.date = DateFormat.yMMMd().format(DateTime.now());

    int result;
    if (note.id != null) {
      //update
      result = await helper.updateNote(note);
    } else {
      //add
      result = await helper.insertNote(note);
    }
    if (result != 0) {
      //success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      //failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: if new note is deleted//fab button
    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: if deleting after adding
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
