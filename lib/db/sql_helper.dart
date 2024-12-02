import 'package:path/path.dart';
import 'package:note_project/models/todo.dart';
import 'package:note_project/models/user.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static late Database _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todo_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        email TEXT,
        password TEXT
      )
      ''');
    await db.execute('''
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT
      )
      ''');
  }

  Future<int> insertUser(UserModel user) async {
    final Database db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<UserModel?> loginUser(String email, String password) async {
    final Database db = await database;
    List<Map<String, dynamic>> result = await db.query('users',
        where: 'email = ? AND password = ?', whereArgs: [email, password]);
    if (result.isEmpty) {
      return null;
    } else {
      return UserModel.fromMap(result.first);
    }
  }

  Future<int> insertTodo(TodoModel todo) async {
    final Database db = await database;
    return await db.insert('todos', todo.toMap());
  }

  Future<List<TodoModel>> fetchTodos() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos');
    return List.generate(maps.length, (i) {
      return TodoModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
      );
    });
  }

  Future<int> updateTodo(TodoModel todo) async {
    final db = await database;
    return await db
        .update('todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<int> deleteTodo(int id) async {
    final db = await database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
