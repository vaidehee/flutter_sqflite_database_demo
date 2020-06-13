import 'package:flutter/material.dart';
import 'NoteDetails.dart';
import 'dart:async';
import 'package:flutter_sqliite_database/Models/Note.dart';
import 'package:flutter_sqliite_database/Utils/DataBaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_sqliite_database/UiScreens/NoteDetails.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DataBaseHelper dataBaseHelper = new DataBaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    return new Scaffold(
      appBar: new AppBar(
        title: Text("Simply Notes"),
      ),
      body: getNotListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Note(2, '', ''), 'Add Note');
        },
        tooltip: "Add Quote",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNotListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    getPriorityColors(this.noteList[position].priority),
                child: getPriorityIcon(this.noteList[position].priority),
              ),
              title: Text(
                this.noteList[position].title,
                style: textStyle,
              ),
              subtitle: Text(this.noteList[position].date),
              trailing: GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    _delete(context, noteList[position]);
                  }),
              onTap: () {
                navigateToDetail(this.noteList[position], "Edit Note");
              },
            ),
          );
        });
  }

//Return Priority color
  Color getPriorityColors(int priority) {
    switch (priority) {
      case 1:
        return Colors.redAccent;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  //return Priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.album);
        break;
      case 2:
        return Icon(Icons.album);
        break;

      default:
        return Icon(Icons.album);
    }
  }

  //Delete Note
  void _delete(BuildContext context, Note note) async {
    int result = await dataBaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, "Note Deleted Succesfully");
      updateListView();
    }
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetails(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackbar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void updateListView() {
    final Future<Database> dbFuture = dataBaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = dataBaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
