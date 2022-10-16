import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:example/db/ImgInfo.dart';

class DBProvider {

  DBProvider._();
  static final DBProvider instance = DBProvider._();
  factory DBProvider() => instance;

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
    print('DB Directory $path');

    return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async{
    final idType='INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType='BOOLEAN NOT NULL';
    final integerType='INTEGER NOT NULL';
    final textType='TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE $TableName(
    ${ImgFields.id} $idType,
    ${ImgFields.info} $boolType,
    ${ImgFields.age} $integerType,
    ${ImgFields.image} $textType,
    ${ImgFields.gender} $textType,
    ${ImgFields.name} $textType,
    ${ImgFields.banner} $textType,
    ${ImgFields.ad} $textType
    )
    ''');
  }

  Future<ImgInfo> create(ImgInfo info) async{
    final db=await instance.database;

    final id= await db.insert(TableName, info.toMap());

    return info.copy(id:id);
  }

  Future<ImgInfo> readImage(int id) async{
    final db=await instance.database;

    final maps=await db.query(
      TableName,
      columns: ImgFields.values,
      where: '${ImgFields.id}=?',
      whereArgs: [id]
    );

    if(maps.isNotEmpty){
      return ImgInfo.fromJson(maps.first);
    }
    else{
      throw Exception('ID $id not found');
    }
  }

  Future<List<ImgInfo>> readAllImage() async{
    final db=await instance.database;

    final result=await db.query(TableName);

    return result.map((json)=>ImgInfo.fromJson(json)).toList();
  }


  Future<int> update(int id, ImgInfo info) async{
    final db=await instance.database;

    return db.update(
      TableName,
      info.toMap(),
      where: '${ImgFields.id}=?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async{
    final db=await instance.database;

    return await db.delete(
      TableName,
      where: '${ImgFields.id}=?',
      whereArgs: [id]
    );
  }
  Future close() async{
    final db = await instance.database;

    db.close();
  }



}