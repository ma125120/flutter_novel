import 'package:flutter_novel/common/http/API.dart';
// import 'package:flutter_novel/data/article.dart';
import 'package:flutter_novel/data/novel.dart';
import 'package:flutter_novel/models/novel.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'novel.g.dart';

// This is the class used by rest of your codebase
class NovelStore = _NovelStore with _$NovelStore;

// The store-class
abstract class _NovelStore with Store {
  @observable
  List<Novel> list = [];

  getList() async {}

  @action
  getShelf([bool needUpdate = false]) async {
    List<Novel> _list = await novelProvider.getShelf();
    if (needUpdate) {
      for (int i = 0; i < _list.length; i++) {
        Novel item = await API.getLatest(_list[i]);
        _list[i] = item;
      }
    }
    list = _list;
    return list;
  }

  @action
  delete(String id, int idx) async {
    await novelProvider.delete(id);
    List<Novel> _list = await novelProvider.getShelf();
    list = _list;
  }

  @action
  destory() {
    novelProvider.destory();
  }
}

NovelStore novelStore = NovelStore();
