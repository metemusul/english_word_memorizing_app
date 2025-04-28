import 'package:english_word_app/db/models/lists.dart';
import 'package:english_word_app/db/models/words.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  
  static final DB instance = DB._init();
  static Database? _database;

  DB._init();

  Future<Database> get database async
  {
    if (_database != null)  return _database!;

    _database = await _initDB('qwordazy.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async
  {
    final path = join(await getDatabasesPath(),filePath);
    return await openDatabase(path,version: 1,onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async
  {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final textType = 'TEXT NOT NULL';


    await db.execute('''

      CREATE TABLE IF NOT EXISTS $tableNameLists(
      ${ListsTableFields.id} $idType,
      ${ListsTableFields.name} $textType
      )

''');


    await db.execute('''
       CREATE TABLE IF NOT EXISTS $tableNameWords(
        ${WordTableFields.id} $idType, 
        ${WordTableFields.list_id} $integerType, 
        ${WordTableFields.word_eng} $textType, 
        ${WordTableFields.word_tr} $textType, 
        ${WordTableFields.status} $boolType, 
        FOREIGN KEY(${WordTableFields.list_id}) REFERENCES $tableNameLists (${ListsTableFields.id}))

''');

  }

Future<Lists> insertList(Lists lists) async
{
  final db = await instance.database;
  final id = await db.insert(tableNameLists, lists.toJson());
  return lists.copy(id: id);
}

Future<Word> insertWord(Word word) async
{
  final db = await instance.database;
  final id = await db.insert(tableNameWords, word.toJson());
  return word.copy(id: id);
}
Future<List<Word>> readWordByList(int ?ListID) async
{
  final db = await instance.database;
  final orderBy = '${WordTableFields.id} ASC';
  final result = await db.query(tableNameWords,orderBy: orderBy,where: '${WordTableFields.list_id} = ?',whereArgs: [ListID]);
  return result.map((json) => Word.fromJson(json)).toList();
}
Future<List<Lists>> readListsAll() async
{
  final db = await instance.database;
  final orderBy = '${ListsTableFields.id} ASC';
  final result = await db.query(tableNameLists,orderBy: orderBy);
  return result.map((json) => Lists.fromJson(json)).toList();
}

Future<int> updateWord(Word word) async
{
    final db = await instance.database;
    return db.update(tableNameWords, word.toJson(),where:'${WordTableFields.id} = ?',whereArgs: [word.id] );
}
Future<int> updateList(Lists lists) async
{
    final db = await instance.database;
    return db.update(tableNameLists, lists.toJson(),where:'${ListsTableFields.id} = ?',whereArgs: [lists.id] );
}
Future<int> deleteWord(int id) async
{
    final db = await instance.database;
    return db.delete(tableNameWords,where: '${WordTableFields.id} =  ? ',whereArgs:[id] );
}
Future<int> deleteListsAndWordByList(int id) async
{
    final db = await instance.database;
    int result = await db.delete(tableNameLists,where: '${ListsTableFields.id} = ?' ,whereArgs: [id]);
    if (result == 1) 
    {
      await db.delete(tableNameWords,where: '${WordTableFields.list_id} = ?' ,whereArgs: [id]);
    }

    return result;
}

Future close() async
{
      final db = await instance.database;
    db.close();
}











}