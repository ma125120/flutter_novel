import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_novel/common/adapt.dart';
import 'package:flutter_novel/common/const.dart';
import 'package:flutter_novel/components/article/img.dart';
import 'package:flutter_novel/components/article/index.dart';
import 'package:flutter_novel/components/index.dart';
// import 'package:flutter_novel/data/novel.dart';
import 'package:flutter_novel/models/novel.dart';
import 'package:flutter_novel/router/index.dart';
import 'package:flutter_novel/store/index.dart';
import 'package:flutter_novel/store/novel.dart';

class BookShelfPage extends StatefulWidget {
  static handler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        return BookShelfPage();
      },
    );
  }

  @override
  _BookShelfPageState createState() => _BookShelfPageState();
}

class _BookShelfPageState extends State<BookShelfPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  get list => novelStore.list;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    // fetchData();
  }

  fetchData() async {
    if (loading) return;
    loading = true;
    await novelStore.getShelf(true);
    loading = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: Observer(
          builder: (_) => EasyRefresh.custom(
                  firstRefresh: true,
                  header: MaterialHeader(),
                  onRefresh: () async {
                    await fetchData();
                    return;
                  },
                  slivers: [
                    // buildAppBar(),
                    buildBody(),
                  ])),
    );
  }

  buildAppBar() {
    return AppBar(
      title: Text('书架'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.search);
          },
        )
      ],
    );
  }

  buildBody() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, idx) {
        Novel item = list[idx];
        double gap = MyConst.gap;

        return MyInk(
          onTap: () {
            Navigator.of(context).pushNamed(Routes.reader, arguments: item);
          },
          onLongPress: () {
            showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text('提示'),
                    content: Text('确认删除吗？'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text('取消'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text('确认'),
                        onPressed: () async {
                          await novelStore.delete(item.id, idx);
                          Navigator.pop(context);
                          BotToast.showSimpleNotification(title: '删除成功');
                        },
                      ),
                    ],
                  );
                });
          },
          child: Container(
            padding: EdgeInsets.only(top: gap, left: gap, right: gap),
            // decoration: BoxDecoration(color: Colors.white),
            child: buildItem(item),
          ),
        );
      }, childCount: list.length),
    );
  }

  buildItem(Novel item) {
    Widget latestWidget = Transform.rotate(
      angle: pi / 4,
      child: TextLabel(
        '更新',
        bg: Colors.amber[700],
        color: Colors.white,
        size: Adapt.px(20),
        margin: EdgeInsets.zero,
        padding: EdgeInsets.symmetric(
            vertical: Adapt.px(8), horizontal: Adapt.px(20)),
      ),
    );

    return Row(
      children: <Widget>[
        Stack(
          children: <Widget>[
            MyNetImage(item.img),
            if (item.canUpdate)
              Positioned(
                child: latestWidget,
                right: 0,
                top: Adapt.px(20),
              ),
          ],
        ),
        Container(
          width: Adapt.px(16),
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  item.name,
                  style: TextStyle(fontSize: Adapt.px(32)),
                ),
                Container(width: Adapt.px(24)),
              ],
            ),
            TextLabel(
              '最新：${item.lastChapter}',
              size: Adapt.px(28),
              padding: EdgeInsets.zero,
              margin: EdgeInsets.only(top: Adapt.px(20), bottom: Adapt.px(20)),
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.access_time,
                  size: Adapt.px(24),
                  // color: MyConst.mediumTextColor,
                ),
                Container(
                  width: Adapt.px(8),
                ),
                Text(
                  item.updateTime,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      // color: Theme.of(context).accentTextTheme.overline.color,
                      fontSize: Adapt.px(24)),
                )
              ],
            ),
          ],
        )),
        Container(
          width: Adapt.px(16),
        ),
      ],
    );
  }
}
