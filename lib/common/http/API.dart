// import 'package:flutter/material.dart';
import 'package:flutter_novel/models/article.dart';
import 'package:flutter_novel/models/novel.dart';

import './http_request.dart';
// import 'package:flutter_novel/models/index.dart';

typedef RequestCallBack<T> = void Function(T value);

class UrlPrefix {
  static bool isMock = false;
  static String activity = (isMock ? '/14' : '') + '/activity';
}

class API {
  static init() {
    HttpRequest.init();
  }

  static String storyList = UrlPrefix.activity + '/activity/story/content';

  static _getRes(String uri,
      {Map<String, String> params,
      Map<String, String> headers,
      Map<String, dynamic> extra,
      bool needLoading = false}) async {
    // if (UrlPrefix.isMock == true) {
    //   return HttpRequest.get(uri, params: params, headers: headers);
    // }
    return HttpRequest.get(uri,
        // data: data,
        params: params,
        headers: headers,
        extra: extra,
        needLoading: needLoading);
  }

  // static _postRes(String uri,
  //     {Map<String, String> params,
  //     Map<String, String> data,
  //     Map<String, String> headers,
  //     Map<String, dynamic> extra,
  //     bool needLoading = true}) async {
  //   // if (UrlPrefix.isMock == true) {
  //   //   return HttpRequest.post(uri,
  //   //       data: data,
  //   //       params: params,
  //   //       headers: headers,
  //   //       extra: extra,
  //   //       needLoading: needLoading);
  //   // }
  //   return HttpRequest.post(uri,
  //       data: data,
  //       params: params,
  //       headers: headers,
  //       extra: extra,
  //       needLoading: needLoading);
  // }

  // static Future<StoryListRes> getStoryList() async {
  //   dynamic res = await _postRes(storyList, needLoading: true);
  //   return StoryListRes.fromJson(res == null ? {} : res);
  // }
  static Future<List<Novel>> searchNovel(text) async {
    List res = await _getRes(
        'https://souxs.pigqq.com/search.aspx?key=$text&page=1&siteid=app2');
    return (res ?? []).map((v) => Novel.fromJson(v)).toList();
  }

  static Future<Novel> getLatest(Novel item) async {
    String id = item.id;

    Map res = await _getRes(
        'https://infosxs.pigqq.com/BookFiles/Html/${_get3(id)}/$id/info.html');
    item.lastChapter = res['LastChapter'];
    item.lastChapterId = res['LastChapterId'].toString();
    item.updateTime = res['LastTime'];

    return item;
  }

  static getChapters(id) async {
    Map res = await _getRes(
        'https://infosxs.pigqq.com/BookFiles/Html/${_get3(id)}/$id/index.html');
    List list = formatChapters(res);
    return (list ?? []).map((v) => Article.fromJson(v)).toList();
  }

  static getArticle(String id, String chapterId) async {
    Map res = await _getRes(
        'https://contentxs.pigqq.com/BookFiles/Html/${_get3(id)}/$id/$chapterId.html');
    res['id'] = res['cid'].toString();
    res['name'] = res['cname'];
    res['prevId'] = res['pid'] == -1 ? null : res['pid'].toString();
    res['nextId'] = res['nid'] == -1 ? null : res['nid'].toString();
    String content = res['content'] ?? '';
    content = content.replaceAll(new RegExp(r'\s{4,}'), '\n        ');
    // .replaceAll('\r\n　　\r\n', '\r\n').replaceAll('        ', '    ');
    res['content'] = content;

    return Article.fromJson(res);
  }

  static getDetail(String id) async {
    Map res = await _getRes(
        'https://infosxs.pigqq.com/BookFiles/Html/${_get3(id)}/$id/info.html');
    res['LastChapterId'] = res['LastChapterId'].toString();
    res['Id'] = res['Id'].toString();
    res['CId'] = res['CId'].toString();
    return res;
  }
}

_get3(String str) {
  if (str.length <= 3) return '1';
  if (str.length <= 4) return int.parse(str.substring(0, 1)) + 1;
  if (str.length <= 5) return int.parse(str.substring(0, 2)) + 1;

  return int.parse(str.substring(0, 3)) + 1;
}

Map mockChapters = {
  'id': 146789,
  'name': '剑来',
  'list': [
    {
      'name': '卷名1',
      'list': [
        {'id': 121, 'hasContent': 1, 'name': '第一章 惊蛰'},
        {'id': 121, 'hasContent': 1, 'name': '第二章 撒大惊蛰'},
      ]
    },
    {
      'name': '卷名2',
      'list': [
        {'id': 121, 'hasContent': 1, 'name': '第一章 惊蛰'},
        {'id': 121, 'hasContent': 1, 'name': '第二章 撒大惊蛰'},
      ]
    },
  ]
};

List<Map> formatChapters(Map map) {
  List<Map> list = [];
  int total = map['list'].length;

  for (var i = 0; i < total; i++) {
    Map item = map['list'][i];
    int len = item['list'].length;

    for (var j = 0; j < len; j++) {
      Map v = item['list'][j];
      v['id'] = v['id'].toString();

      if (j == 0) {
        v['volumeName'] = item['name'];
      }

      list.add(v);
    }
  }

  // int _len = list.length;
  // for (int i = 0; i < _len - 1; i++) {
  //   list[i]['nextId'] = list[i + 1]['id'];
  // }
  // print(list);

  return list;
}
