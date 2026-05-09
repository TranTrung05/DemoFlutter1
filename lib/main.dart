import 'package:flutter/material.dart';
import 'screens/note_list_screen.dart';
import 'screens/vocab_list_screen.dart';
import 'screens/flashcard_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ghi chú + Học từ vựng',
      theme: ThemeData(primarySwatch: Colors.blue),
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