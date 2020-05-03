import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_novel/common/adapt.dart';
import 'package:flutter_novel/common/const.dart';
import 'package:flutter_novel/common/fn.dart';
import 'package:flutter_novel/common/http/API.dart';
import 'package:flutter_novel/components/article/index.dart';
import 'package:flutter_novel/components/index.dart';
import 'package:flutter_novel/models/article.dart';
import 'package:flutter_novel/models/novel.dart';
import 'package:flutter_novel/router/index.dart';

class ChapterPage extends StatefulWidget {
  ChapterPage({
    this.id,
    this.novel,
  });
  final String id;
  final Novel novel;

  static handler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        return ChapterPage(
            id: getParams(context, 'id'), novel: getParams(context, 'novel'));
      },
    );
  }

  @override
  _ChapterPageState createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  List<Article> list = [];
  double itemHeight = 12.0 * 2 + 20;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    list = await API.getChapters(widget.id);
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('目录'),
      ),
      body: CupertinoScrollbar(child: buildList()),
    );
  }

  buildList() {
    return ListView.builder(
      itemExtent: itemHeight,
      controller: _scrollController,
      padding: EdgeInsets.zero,
      itemBuilder: (__, idx) {
        Article item = list[idx];

        return MyInk(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: TextLabel(
                  item.name,
                  color: item.id == widget.id ? MyConst.primary : null,
                  size: 14,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  margin: EdgeInsets.all(0),
                ),
              ),
              if (item.content != null)
                TextLabel(
                  '已缓存',
                  size: 12,
                  color: MyConst.lowTextColor,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  margin: EdgeInsets.all(0),
                )
            ],
          ),
          onTap: () {
            Novel _novel = widget.novel;
            _novel.currentChapterId = item.id;
            _novel.currentPageIndex = 0;

            Navigator.pushNamed(context, Routes.reader, arguments: _novel);
            // widget.onSelect(item);
          },
        );
      },
      itemCount: list.length,
    );
  }
}
