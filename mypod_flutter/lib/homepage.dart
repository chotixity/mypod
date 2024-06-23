import 'package:flutter/material.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:mypod_client/mypod_client.dart';
import 'package:mypod_flutter/loading_screen.dart';
import './note_dialog.dart';
import './main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<Note>? _notes;
  Exception? _connectionException;

  void _connectionFailed(dynamic exception) {
    setState(() {
      _notes = null;
      _connectionException = exception;
    });
  }

  Future<void> _loadNotes() async {
    try {
      final notes = await client.notes.getAllNotes();
      setState(() {
        _notes = notes;
      });
    } catch (e) {
      _connectionFailed(e);
    }
  }

  Future<void> _createNote(Note note) async {
    try {
      await client.notes.createNote(note);
      await _loadNotes();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  Future<void> _updateNote(Note note) async {
    try {
      await client.notes.editNote(note);
      await _loadNotes();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  Future<void> _deleteNote(Note note) async {
    try {
      await client.notes.deleteNote(note);
      await _loadNotes();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircularUserImage(
          userInfo: sessionManager.signedInUser,
          size: 30,
        ),
        title: Text(sessionManager.signedInUser!.userName!),
        actions: [
          TextButton.icon(
            onPressed: () {
              sessionManager.signOut();
            },
            label: const Text('Sign Out'),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _notes == null
          ? LoadingScreen(
              onTryAgain: _loadNotes,
              exception: _connectionException,
            )
          : ListView.builder(
              itemCount: _notes!.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text(_notes![index].text),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showNoteDialog(
                            context: context,
                            text: _notes![index].text,
                            onSaved: (text) {
                              setState(() {
                                _notes![index].text = text;
                              });

                              _updateNote(_notes![index]);
                            },
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          var note = _notes![index];

                          setState(() {
                            _notes!.remove(note);
                          });

                          _deleteNote(note);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              }),
            ),
      floatingActionButton: _notes == null
          ? null
          : FloatingActionButton(
              onPressed: () {
                showNoteDialog(
                  context: context,
                  onSaved: (text) {
                    var note = Note(
                      createdById: sessionManager.signedInUser!.id!,
                      text: text,
                    );
                    _notes!.add(note);

                    _createNote(note);
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
