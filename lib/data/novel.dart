import 'dart:io';

import 'package:flutter_novel/common/const.dart';
import 'package:flutter_novel/models/novel.dart';
import 'package:sqflite/sqflite.dart';

final String _tableName = 'novel';
// final String novelPath = '_novel';

class NovelProvider {
  Database db;

  Future open() async {
    db = await openDatabase(MyConst.dbPath, version: 3,
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
      await db.execute('''
          ALTER TABLE $_tableName ADD 'lastReadTime' INTEGER NOT NULL DEFAULT 0
        ''');
    }, onCreate: (Database db, int version) async {
      await db.execute('''
          create table $_tableName ( 
            Id text primary key, 
            Name text not null,
            Author text not null,
            Img text not null,
            Desc text not null,
            BookStatus text not null,
            LastChapterId text not null,
            LastChapter text not null,
            CName text not null,
            UpdateTime text not null,
            isExist INTEGER DEFAULT 0,
            storeLastChapterId text ,
            currentChapterId text,
            currentPageIndex INTEGER DEFAULT 0,
            lastReadTime INTEGER NOT NULL DEFAULT 0
            )
        ''');
    });
  }

  Future<Novel> insert(Novel novel) async {
    await open();
    novel.isExist = 1;
    novel.lastReadTime = DateTime.now().millisecondsSinceEpoch;
    await db.insert(_tableName, novel.toJson());
    return novel;
  }

  Future<Novel> update(Novel novel) async {
    novel.lastReadTime = DateTime.now().millisecondsSinceEpoch;
    await open();
    try {
      await db.update(_tableName, novel.toJson(),
          whereArgs: [novel.id], where: 'id = ?');
    } catch (err) {
      print(err);
    }

    return novel;
  }

  Future<List<Novel>> getShelf() async {
    await open();
    List<Map> maps = await db.query(
      _tableName,
      orderBy: 'lastReadTime DESC',
    );

    return maps.map((v) => Novel.fromJson(v)).toList();
  }

  delete(String id) async {
    await open();
    await db.delete(_tableName, whereArgs: [id], where: 'id = ?');
  }

  destory() async {
    String rootPath = await getDatabasesPath();
    File('$rootPath/${MyConst.dbPath}').delete(recursive: true);
  }
}

NovelProvider novelProvider = NovelProvider();
