import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/vocab.dart';

class VocabListScreen extends StatefulWidget {
  @override
  _VocabListScreenState createState() => _VocabListScreenState();
}

class _VocabListScreenState extends State<VocabListScreen> {
  List<Vocab> _vocabs = [];
  final db = DatabaseHelper();

  void _loadVocabs() async {
    final list = await db.getVocabs();
    setState(() {
      _vocabs = list;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadVocabs();
  }
 // Tạo hộp thoại động
  void _showEditDialog({Vocab? vocab}) {
    // tọa các controllers và điền dữ liệu vào vocab cũ
    final wordCtrl = TextEditingController(text: vocab?.word ?? '');// vocab null thì chuỗi rỗng , k null thì lấy vocab.word
    final meanCtrl = TextEditingController(text: vocab?.meaning ?? '');
    final exCtrl = TextEditingController(text: vocab?.example ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(vocab == null ? 'Thêm từ' : 'Sửa từ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          // 3 Text Feild
          children: [
            TextField(controller: wordCtrl, decoration: InputDecoration(labelText: 'Từ vựng')),
            TextField(controller: meanCtrl, decoration: InputDecoration(labelText: 'Nghĩa')),
            TextField(controller: exCtrl, decoration: InputDecoration(labelText: 'Ví dụ')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Hủy')),
          TextButton(
            onPressed: () async {
              // lấy dữ liẹue , tạo vocab mới gọi 2 hàm insert và update
              if (wordCtrl.text.isNotEmpty) {
                final newVocab = Vocab(
                  id: vocab?.id,
                  word: wordCtrl.text,
                  meaning: meanCtrl.text,
                  example: exCtrl.text,
                );
                if (vocab == null) {
                  await db.insertVocab(newVocab);
                } else {
                  await db.updateVocab(newVocab);
                }
                _loadVocabs();// cập nhật lại
                Navigator.pop(context);// đóng dialog
              }
            },
            child: Text('Lưu'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteVocab(int id) async {
    await db.deleteVocab(id);
    _loadVocabs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Từ vựng')),
      body: ListView.builder(
        itemCount: _vocabs.length,
        itemBuilder: (ctx, i) {
          final v = _vocabs[i];
          return ListTile(
            title: Text(v.word),
            subtitle: Text(v.meaning),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: Icon(Icons.edit), onPressed: () => _showEditDialog(vocab: v)),
                IconButton(icon: Icon(Icons.delete), onPressed: () => _deleteVocab(v.id!)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showEditDialog(),
      ),
    );
  }
}