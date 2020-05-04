import 'dart:io';

import 'package:flutter_novel/common/const.dart';
import 'package:flutter_novel/common/http/API.dart';
import 'package:flutter_novel/models/article.dart';
import 'package:sqflite/sqflite.dart';

String getDbName(String name) {
  return name.startsWith('novel') ? name : 'novel_$name';
}

String getSqlField(String str) {
  return str == null ? null : "'$str'";
}

class ArticleProvider {
  Database db;

  Future open(String tableName) async {
    db = await openDatabase(MyConst.dbPath + '_$tableName', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          create table ${getDbName(tableName)} ( 
            id text primary key, 
            name text not null,
            content text,
            volumeName text,
            prevId text,
            nextId text
          )
        ''');
    });
  }

  Future<List<Article>> insertMany(String dbName, List<Article> list) async {
    await open(dbName);
    String querySql = list.map((v) {
      return "('${v.id}', '${v.name}', ${getSqlField(v.content)}, ${getSqlField(v.volumeName)}, ${getSqlField(v.prevId)}, ${getSqlField(v.nextId)})";
    }).join(',');

    await db.execute('''
      INSERT INTO ${getDbName(dbName)}(id, name, content, volumeName, prevId, nextId)
      VALUES $querySql;
    ''');
    return list;
  }

  Future<Article> insert(String dbName, Article item) async {
    await open(dbName);
    try {
      await db.insert(getDbName(dbName), item.toJson());
    } catch (err) {
      print(err);
    }

    return item;
  }

  Future<List<Article>> getChapters(String dbName) async {
    await open(dbName);
    List<Map> maps = await db.query(
      getDbName(dbName),
      // columns: ['id', 'name', 'volumeName', 'prevId', 'nextId'],
    );
    return maps.map((v) => Article.fromJson(v)).toList();
  }

  updateChapter(String dbName, Article item) async {
    await open(dbName);
    await db.update(getDbName(dbName), item.toJson(),
        where: 'id = ?', whereArgs: [item.id]);
  }

  updateChapters(String dbName, List<Article> nowList) async {
    List<Article> prevList = await getChapters(dbName);
    if (prevList.length >= nowList.length) return;
    List<Article> list = nowList.sublist(prevList.length);
    Article last = prevList.last;
    last.nextId = list?.first?.id;
    await insert(dbName, last);

    await insertMany(dbName, list);
  }

  Future<Article> getArticle(String dbName, String chapterId) async {
    List<Map> list = await db
        .query(getDbName(dbName), where: 'id = ?', whereArgs: [chapterId]);
    Article item;
    if (list.length > 0) {
      item = Article.fromJson(list.first);
      if (item.content == null) {
        Article _item = await API.getArticle(dbName, chapterId);
        _item.volumeName = item.volumeName;
        item = _item;
        await updateChapter(dbName, item);
      }
      // print(item.content);
      return item;
    }

    return null;
  }

  delete(String dbPath, String id) async {
    await open(dbPath);
    await db.delete(getDbName(dbPath), where: 'id = ?', whereArgs: [id]);
  }

  deleteAll(String dbPath) async {
    await open(dbPath);
    await db.delete(getDbName(dbPath));
  }

  destory(name) async {
    String rootPath = await getDatabasesPath();
    File('$rootPath/${MyConst.dbPath + "_" + name}').delete(recursive: true);
  }
}

ArticleProvider articleProvider = ArticleProvider();
