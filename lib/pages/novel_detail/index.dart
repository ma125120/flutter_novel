import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_novel/common/adapt.dart';
import 'package:flutter_novel/common/const.dart';
import 'package:flutter_novel/common/fn.dart';
import 'package:flutter_novel/common/http/API.dart';
import 'package:flutter_novel/components/article/img.dart';
import 'package:flutter_novel/components/index.dart';
import 'package:flutter_novel/data/novel.dart';

import 'package:flutter_novel/models/novel.dart';
import 'package:flutter_novel/router/index.dart';
import 'package:flutter_novel/store/novel.dart';

class NovelDetailPage extends StatefulWidget {
  NovelDetailPage({
    this.id,
  });
  final String id;

  static handler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        return NovelDetailPage(id: getParams(context, 'id'));
      },
    );
  }

  @override
  _NovelDetailPageState createState() => _NovelDetailPageState();
}

class _NovelDetailPageState extends State<NovelDetailPage> {
  Map info = {};

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    String id = widget.id;
    Map _info = await API.getDetail(id);
    info = _info;

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 240,
                centerTitle: true,
                floating: true,
                pinned: true,
                title: Text(info['Name'] ?? '书籍'),
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: <StretchMode>[
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                    StretchMode.fadeTitle,
                  ],
                  centerTitle: true,
                  // title: Text('书籍'),
                  background: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.asset(
                        'img/blur.jpg',
                        fit: BoxFit.fill,
                      ),
                      DefaultTextStyle(
                        child: buildHeader(),
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              buildGrey(),
              buildDesc(),
              buildGrey(),
              buildMenu(),
              buildGrey(),
              if (info['SameUserBooks'] != null &&
                  info['SameUserBooks'].length > 0)
                _renderSection(title: '${info['Author'] ?? ''} 还写过'),
              if (info['SameUserBooks'] != null) buildUserBooks(),
              SliverToBoxAdapter(
                child: Container(
                  height: 50,
                ),
              ),
            ],
          ),
          buildBottom(),
        ],
      ),
    );
  }

  insert(Novel item) async {
    try {
      await novelProvider.insert(item);
      BotToast.showSimpleNotification(title: '已成功加入到书架');
      novelStore.getShelf();
    } catch (err) {
      BotToast.showSimpleNotification(title: '可能已存在于书架，添加失败');
    }
  }

  buildBottom() {
    return Positioned(
      bottom: -6,
      left: 0,
      // right: 0,
      width: Adapt.width,
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              textColor: MyConst.primary,
              color: Colors.white,
              child: Text('加入书架'),
              onPressed: () {
                insert(Novel.fromJson(info));
              },
            ),
          ),
          Expanded(
            child: FlatButton(
              textColor: Colors.white,
              padding: EdgeInsets.zero,
              color: MyConst.primary,
              child: Text('立即阅读'),
              onPressed: () {
                Navigator.pushNamed(context, Routes.reader,
                    arguments: Novel.fromJson(info));
              },
            ),
          ),
        ],
      ),
    );
  }

  buildHeader() {
    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MyNetImage(
              'https://imgapixs.pigqq.com/BookFiles/BookImages/${info['Img']}'),
          Container(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  info['Name'] ?? '',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                  height: 12,
                ),
                Text('作者：${info['Author'] ?? ''}'),
                Container(
                  height: 6,
                ),
                Text('类型：${info['CName'] ?? ''}'),
                Container(
                  height: 6,
                ),
                Text('状态：${info['BookStatus'] ?? ''}'),
              ],
            ),
          )
        ],
      ),
    );
  }

  buildGrey() {
    return SliverToBoxAdapter(
      child: Container(
        height: 8,
        decoration: BoxDecoration(color: Color(0xffF0F0F0)),
      ),
    );
  }

  buildDesc() {
    return _renderSection(
        child: Text(
          info['Desc'] ?? '',
          style: TextStyle(fontSize: 13, height: 1.2),
        ),
        title: '简介:');
  }

  buildMenu() {
    return SliverToBoxAdapter(
      child: MyInk(
        onTap: () {
          Navigator.pushNamed(context, Routes.chapter, arguments: {
            'id': widget.id,
            'novel': Novel.fromJson(info),
          });
        },
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('目录:'),
              Container(
                height: 6,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.menu,
                    // color: MyConst.lowTextColor,
                    size: 16,
                  ),
                  Container(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          '最近更新：${info['LastTime'] ?? ''}',
                          // style: TextStyle(color: MyConst.lowTextColor),
                        ),
                        Container(
                          height: 4,
                        ),
                        Text(
                          '${info['LastChapter'] ?? ''}',
                          overflow: TextOverflow.ellipsis,
                          // style: TextStyle(color: MyConst.mediumTextColor),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    // color: MyConst.lowTextColor,
                  ),
                ],
              ),
            ],
          ),
          padding: EdgeInsets.all(12),
        ),
      ),
    );
  }

  _renderSection({Widget child, String title = ''}) {
    return SliverToBoxAdapter(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title),
            Container(
              height: 6,
            ),
            if (child != null) child,
          ],
        ),
        padding: EdgeInsets.all(12),
      ),
    );
  }

  SliverList buildUserBooks() {
    List list = info['SameUserBooks'];

    Widget Function(BuildContext ctx, int idx) itemBuilder = (ctx, idx) {
      Map item = list[idx];

      return MyInk(
        onTap: () {
          Navigator.pushNamed(context, Routes.detail,
              arguments: {'id': item['Id'].toString()});
        },
        child: Container(
          padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
          child: Row(
            children: <Widget>[
              MyNetImage(
                  'https://imgapixs.pigqq.com/BookFiles/BookImages/${item['Img']}'),
              Container(
                width: 16,
              ),
              _renderColumn(children: [
                Text(
                  '${item['Name']}',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Container(
                  height: 12,
                ),
                Text(
                  '作者：${item['Author']}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Container(
                  height: 6,
                ),
                Text(
                  '最新：${item['LastChapter']}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ])
            ],
          ),
        ),
      );
    };

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        itemBuilder,
        childCount: (list?.length) ?? 0,
      ),
    );
  }

  Widget _renderColumn({
    List<Widget> children = const [],
  }) {
    Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );

    return body;
  }
}
