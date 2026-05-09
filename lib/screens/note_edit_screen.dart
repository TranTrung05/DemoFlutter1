import 'package:flutter/material.dart';
import '../models/note.dart';
import '../database/database_helper.dart';

class NoteEditScreen extends StatefulWidget {
  final Note? note;
  NoteEditScreen({this.note});

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final db = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty) return;

    if (widget.note == null) {
      final newNote = Note(
        title: title,
        content: content,
        createdAt: DateTime.now(),
      );
      await db.insertNote(newNote);
    } else {
      final updatedNote = Note(
        id: widget.note!.id,
        title: title,
        content: content,
        createdAt: widget.note!.createdAt,
      );
      await db.updateNote(updatedNote);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.note == null ? 'Thêm ghi chú' : 'Sửa ghi chú')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Tiêu đề')),
            SizedBox(height: 16),
            TextField(controller: _contentController, decoration: InputDecoration(labelText: 'Nội dung'), maxLines: 5),
            SizedBox(height: 32),
            ElevatedButton(onPressed: _save, child: Text('Lưu')),
          ],
        ),
      ),
    );
  }
}