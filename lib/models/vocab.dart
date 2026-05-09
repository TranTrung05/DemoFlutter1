class Vocab {
  int? id;
  String word;
  String meaning;
  String example;

  Vocab({this.id, required this.word, required this.meaning, required this.example});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning,
      'example': example,
    };
  }

  factory Vocab.fromMap(Map<String, dynamic> map) {
    return Vocab(
      id: map['id'],
      word: map['word'],
      meaning: map['meaning'],
      example: map['example'],
    );
  }
}