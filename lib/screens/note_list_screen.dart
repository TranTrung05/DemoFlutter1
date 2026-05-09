import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/note.dart';
import 'note_edit_screen.dart';

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> _notes = [];
  final db = DatabaseHelper();

  void _loadNotes() async {
    final notes = await db.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _deleteNote(int id) async {
    await db.deleteNote(id);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ghi chú')),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (ctx, i) {
          final note = _notes[i];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.content),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteNote(note.id!),
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NoteEditScreen(note: note)),
              );
              _loadNotes();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NoteEditScreen()),
          );
          _loadNotes();
        },
      ),
    );
  }
}