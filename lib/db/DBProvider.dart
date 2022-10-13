import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:example/db/ImageInfo.dart';

class DBProvider {

  DBProvider._();
  static final DBProvider _db = DBProvider._();
  factory DBProvider() => _db;

  static Database? _database;

  /*static final DBProvider instance=DBProvider._init();

  DBProvider._init();
*/
  Future<Database> get database async {
    if(_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ImageInfo.db');

    return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async{
    final idType='INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType='BOOLEAN NOT NULL';
    final integerType='INTEGER';
    final textType='TEXT';
    await db.execute('''
          CREATE TABLE $TableName(
            ${ImageFields.id} $idType,
            ${ImageFields.info} $boolType,
            ${ImageFields.age} $integerType,
            ${ImageFields.image} $textType,
            ${ImageFields.gender} $textType,
            ${ImageFields.name} $textType,
            ${ImageFields.banner} $textType,
            ${ImageFields.ad} $textType,
          )
          ''');
  }

  Future<ImageInfo> create(ImageInfo info) async{
    final db=await _db.database;

    final id= await db.insert(TableName, info.toMap());

    return info.copy(id:id);
  }

  Future<ImageInfo> readNote(int id) async{
    final db=await _db.database;

    final maps=await db.query(
      TableName,
      columns: ImageFields.values,
      where: '${ImageFields.id}=?',
      whereArgs: [id]
    );

    if(maps.isNotEmpty){
      return ImageInfo.fromJson(maps.first);
    }
    else{
      throw Exception('ID $id not found');
    }
  }

  Future<List<ImageInfo>> readAllNote(int id) async{
    final db=await _db.database;

    final result=await db.query(TableName);

    return result.map((json)=>ImageInfo.fromJson(json)).toList();
  }

  
  Future<int> update(ImageInfo info) async{
    final db=await _db.database;

    return db.update(
      TableName,
      info.toMap(),
      where: '${ImageFields.id}=?',
      whereArgs: [info.id],
    );
  }

  Future<int> delete(int id) async{
    final db=await _db.database;

    return await db.delete(
      TableName,
      where: '${ImageFields.id}=?',
      whereArgs: [id]
    );
  }
  Future close() async{
    final db = await _db.database;

    db.close();
  }



}