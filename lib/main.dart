import 'package:flutter/material.dart';
import 'screens/note_list_screen.dart';
import 'screens/vocab_list_screen.dart';
import 'screens/flashcard_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MaterialApp cung cấp các thàn phần design marterial, quản lý điều hướng
    return MaterialApp(
      title: 'Ghi chú + Học từ vựng',
      theme: ThemeData(primarySwatch: Colors.blue),
      // DefaultTabController quản lý trạng thái tarbar , cần length = số tab
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('App học tập'),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.note), text: 'Ghi chú'),
                Tab(icon: Icon(Icons.book), text: 'Từ vựng'),
                Tab(icon: Icon(Icons.style), text: 'Flashcard'),
              ],
            ),
          ),
          // hiện thị nội dụng tương ứng với tab đã chọn , mỗi tab sẽ có 1 witgh riêng nên sẽ gọi từng hàm khác nhau dưới
          body: TabBarView(
            children: [
              NoteListScreen(),
              VocabListScreen(),
              FlashcardScreen(),
            ],
          ),
        ),
      ),
    );
  }
}