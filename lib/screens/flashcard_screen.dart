import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/vocab.dart';

class FlashcardScreen extends StatefulWidget {
  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  List<Vocab> _vocabs = [];
  int _currentIndex = 0;
  bool _showMeaning = false;

  void _loadVocabs() async {
    final list = await DatabaseHelper().getVocabs();
    setState(() {
      _vocabs = list;
      _currentIndex = 0;
      _showMeaning = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadVocabs();
  }

  void _nextCard() {
    if (_currentIndex + 1 < _vocabs.length) {
      setState(() {
        _currentIndex++;
        _showMeaning = false;
      });
    }
  }

  void _prevCard() {
    if (_currentIndex - 1 >= 0) {
      setState(() {
        _currentIndex--;
        _showMeaning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_vocabs.isEmpty) {
      // hiện thị các tbao
      return Scaffold(
        appBar: AppBar(title: Text('Học từ vựng')),
        body: Center(child: Text('Chưa có từ nào , tthêm từ vựng trước')),
      );
    }

    final current = _vocabs[_currentIndex];
    return Scaffold(
      appBar: AppBar(title: Text('Flashcard')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Expanded làm cho Card chiếm hết không gian còn lại ngoại trừ hàng nút
          Expanded(
            // GestureDetector bắt sự kiện khi chạm nút
            child: GestureDetector(
              onTap: () => setState(() => _showMeaning = !_showMeaning),
              child: Card(
                margin: EdgeInsets.all(20),
                elevation: 8,
                child: Center(
                  child: Text(
                    _showMeaning ? '${current.meaning}\n\nVí dụ: ${current.example}' : current.word,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: _prevCard, child: Text('Trước')),
              Text('${_currentIndex+1} / ${_vocabs.length}', style: TextStyle(fontSize: 18)),//
              ElevatedButton(onPressed: _nextCard, child: Text('Sau ')),
            ],
          ),
          SizedBox(height: 16),
          Text('Nhấn vào thẻ để xem nghĩa / ví dụ'),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}