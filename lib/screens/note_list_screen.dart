import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/note.dart';
import 'note_edit_screen.dart';

// dùng StatefulWidget để thay đổi theo thời gian
class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  // hiện thị danh sách ghi chú
  List<Note> _notes = [];
  // lấy ra chỉ 1 instance
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
  }// chỉ chạy khi màn hình được tạo

  Future<void> _deleteNote(int id) async {
    await db.deleteNote(id);
    _loadNotes();// gọi hàm này và lấy data mới từ DB và setState
  }

  @override
  Widget build(BuildContext context) {
    // cấu trúc cơ bản : bar , body , Fab
    return Scaffold(
      appBar: AppBar(title: Text('Ghi chú')),
      // tạo các ưidget cần hiện thị
      body: ListView.builder(
        itemCount: _notes.length,// số phần tử
        // gọi lên khi cần viết thêm 1 dòng
        itemBuilder: (ctx, i) {
          final note = _notes[i];
          // tạo 1 dòng có tiêu đề , phụ đề , icon xóa ở phải
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.content),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteNote(note.id!),
            ),
            // nhấn vào nó push ra hàm NoteEditScreen truyền các tham số của phần tử hiện tại
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
      // nút thêm , k thì push hàm NoteEditScreen k truyền note ( mặc định k có j )
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