import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';
import '../models/vocab.dart';

class DatabaseHelper {
  // tạo biến static private để lưu instance duy nhất(static final)
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  // mỗi lần gọi sẽ trả về _instance
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();
// lưu vào dtbase
  static Database? _database;
// get
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Khởi tạo cơ sở dữ liệu
  Future<Database> _initDatabase() async {
    // lấy đường dẫn của
    String path = join(await getDatabasesPath(), 'note_vocab.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Bảng notes
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            createdAt TEXT
          )
        ''');
        // Bảng vocab (thêm cột example)
        await db.execute('''
          CREATE TABLE vocab(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word TEXT,
            meaning TEXT,
            example TEXT
          )
        ''');
      },
    );
  }

  // ==================== GHI CHÚ ====================
  Future<List<Note>> getNotes() async {
    // lấy kết nôis
    // dùng await để lấy object database thực , nếu dungf get là lấy Future<Database> dòng 23
    final db = await database;

    // db.query trả về list, mỗi map là 1 dòng
    final List<Map<String, dynamic>> maps = await db.query('notes', orderBy: 'createdAt DESC');
    // cho thằng mới nhất lên đầu
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  Future<void> insertNote(Note note) async {
    final db = await database;
    // hàm conflictAlgorithm đc sử dụng nếu id trùng thì sẽ thay thế thành id khacs , hoặc tăng giá trị để đẩy lên đầu
    await db.insert('notes', note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateNote(Note note) async {
    final db = await database;
    // ? : placeholder
    await db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== TỪ VỰNG ====================
  Future<List<Vocab>> getVocabs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('vocab');
    return List.generate(maps.length, (i) => Vocab.fromMap(maps[i]));
  }

  Future<void> insertVocab(Vocab vocab) async {
    final db = await database;
    await db.insert('vocab', vocab.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateVocab(Vocab vocab) async {
    final db = await database;
    await db.update('vocab', vocab.toMap(), where: 'id = ?', whereArgs: [vocab.id]);
  }

  Future<void> deleteVocab(int id) async {
    final db = await database;
    await db.delete('vocab', where: 'id = ?', whereArgs: [id]);
  }
}