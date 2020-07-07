
import 'dart:io';
import 'package:flutter_todos/globals.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'profilemodel.dart';
import 'package:flutter_todos/model/model.dart';
import 'package:camera/camera.dart';
const statusActive = 0;
const statusDone = 1;

const databaseName = 'products.db';
const databaseVersion = 1;
const SQLCreateStatement = '''
CREATE TABLE "products" (
	 "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	 "title" TEXT NOT NULL,
	 "created" text NOT NULL,
	 "updated" TEXT NOT NULL,
	 "status" integer DEFAULT $statusActive
);
CREATE TABLE "profile"(
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "profilepic" TEXT NOT NULL
);
''';

const tableProducts = 'products';
const tableProfile = 'profile';

class DB {
  DB._();
  static final DB sharedInstance = DB._();

  Database _database;
  Future<Database> get database async {
    return _database ?? await initDB();
  }

  Future<Database> initDB() async {
    Directory docsDirectory = await getApplicationDocumentsDirectory();
    String path = join(docsDirectory.path, databaseName);

    return await openDatabase(path, version: databaseVersion,
        onCreate: (Database db, int version) async {
      await db.execute(SQLCreateStatement);
    });
  }

  void createProduct(Product todo) async {
    final db = await database;
    await db.insert(tableProducts, todo.toMapAutoID());
  }

  void createProfile(Profile newProfile) async{
    final db = await database;
    await db.insert(tableProfile, newProfile.toMapAutoID());
  }
  void updateProfile(Profile profile) async{
    final db = await database;
    await db
        .update(tableProfile, profile.toMap(), where: 'id=?', whereArgs: [profile.id]);
  }
  void deleteProfile(Profile profile) async {
    final db = await database;
    await db.delete(tableProfile, where: 'id=?', whereArgs: [profile.id]);
  }
  void updateProduct(Product todo) async {
    final db = await database;
    await db
        .update(tableProducts, todo.toMap(), where: 'id=?', whereArgs: [todo.id]);
  }

  void deleteProduct(Product todo) async {
    final db = await database;
    await db.delete(tableProducts, where: 'id=?', whereArgs: [todo.id]);
  }

  void deleteAllProducts({int status = statusDone}) async {
    final db = await database;
    await db.delete(tableProducts, where: 'status=?', whereArgs: [status]);
  }
  Future<List<Profile>> getProfile() async{
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(profilePicture,where: 'id=1');
    return List.generate(maps.length, (i) {
      return Profile(
        id: maps[i]['id'],
        profilePic: maps[i]['profilepic'],
      );
    });
  }
  Future<List<Product>> retrieveProducts(
      {ProductStatus status = ProductStatus.active}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableProducts,
        where: 'status=?', whereArgs: [status.index], orderBy: 'updated ASC');

    // Convert List<Map<String, dynamic>> to List<Todo_object>
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        title: maps[i]['title'],
        created: DateTime.parse(maps[i]['created']),
        updated: DateTime.parse(maps[i]['updated']),
        status: maps[i]['status'],
      );
    });
  }
}
