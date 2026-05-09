class Note {
  int? id; // tự động tăng id mà k cần setup
  String title;
  String content;
  DateTime createdAt;
// cóntructỏr , id có thể thêm hoặc k , còn lại băts buộc
  Note({this.id, required this.title, required this.content, required this.createdAt});
// sử dụng Map để chuyển đối tượng sang Map để lưu vào dtbase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),// chuyển đôir chuôix
    };
  }

// đọc dữ liệu từ databs -> dart
  // tạo object Note từ Map
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}