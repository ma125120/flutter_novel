import 'package:flutter_novel/common/http/API.dart';
import 'package:flutter_novel/data/article.dart';
import 'package:flutter_novel/data/novel.dart';
import 'package:flutter_novel/models/article.dart';
import 'package:flutter_novel/models/novel.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'article.g.dart';

// This is the class used by rest of your codebase
class ArticleStore = _ArticleStore with _$ArticleStore;

// The store-class
abstract class _ArticleStore with Store {
  @observable
  List<Article> list = const [];
  @observable
  Article currentArticle;
  @observable
  Article prevArticle;
  @observable
  Article nextArticle;

  // @action
  // Future<List<Article>> getChapters(String id) async {
  //   List<Article> list = await articleProvider.getChapters(id);
  //   if (list == null || list.length == 0) {
  //     list = await API.getChapters(id);
  //   }
  //   return list;
  // }
  @action
  getArticleAllInfo(Novel novel) async {
    // articleProvider.destory(novel.id);
    // return;
    String dbName = novel.id;
    // 获取数据库的章节
    List<Article> _list = await articleProvider.getChapters(novel.id);

    // 第一次，需要存储到数据库
    if (_list == null || _list.length == 0) {
      _list = await API.getChapters(novel.id);
      await articleProvider.insertMany(novel.id, _list);
    } else {
      // 有更新的时候，更新数据库的最后一条的nextId，然后插入之后的所有
      List<Article> remoteList = await API.getChapters(novel.id);
      if (remoteList.length > 0) {
        await articleProvider.updateChapters(dbName, remoteList);
      }
      _list = remoteList;
    }

    novel.storeLastChapterId = _list.last?.id;
    novelProvider.update(novel);

    list = _list;
    return list;

    // String cid = novel.currentChapterId;
    // if (cid == null) {
    //   cid = list.first?.id;
    //   novel.currentChapterId = cid;
    //   novelProvider.update(novel);
    // }
    // currentArticle = await getArticle(dbName, novel.currentChapterId);
    // if (currentArticle != null) {
    //   prevArticle = await getArticle(dbName, currentArticle.prevId);
    //   nextArticle = await getArticle(dbName, currentArticle.nextId);
    // }
  }

  getArticle(String dbName, String chapterId) {
    if (chapterId == null) return null;

    return articleProvider.getArticle(dbName, chapterId);
  }
}

ArticleStore articleStore = ArticleStore();
