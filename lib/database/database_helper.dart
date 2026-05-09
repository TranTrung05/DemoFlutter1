import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';
import '../models/vocab.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Khởi tạo cơ sở dữ liệu
  Future<Database> _initDatabase() async {
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
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes', orderBy: 'createdAt DESC');
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  Future<void> insertNote(Note note) async {
    final db = await database;
    await db.insert('notes', note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateNote(Note note) async {
    final db = await database;
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