import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'package:flutter_easyrefresh/phoenix_header.dart';
import 'package:flutter_novel/common/adapt.dart';
import 'package:flutter_novel/common/const.dart';
import 'package:flutter_novel/common/http/API.dart';
import 'package:flutter_novel/components/article/img.dart';
import 'package:flutter_novel/components/article/index.dart';
import 'package:flutter_novel/data/novel.dart';
import 'package:flutter_novel/models/novel.dart';
import 'package:flutter_novel/store/novel.dart';

class SearchPage extends StatefulWidget {
  static handler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        return SearchPage();
      },
    );
  }

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String text = '剑来';
  List<Novel> list = [];

  EasyRefreshController _ctrl;
  bool firstRefresh = false;

  @override
  void initState() {
    super.initState();
    _ctrl = EasyRefreshController();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  search() async {
    List<Novel> novelList = novelStore.list;
    if (novelList.length == 0) {
      novelList = await novelStore.getShelf();
    }

    List<Novel> _list = await API.searchNovel(text);
    _list = _list.map((v) {
      v.isExist = novelList.any((item) => item.id == v.id) ? 1 : 0;
      return v;
    }).toList();
    list = _list;
    setState(() {});
    // _ctrl.finishRefresh(success: true);
  }

  startRefresh() {
    closeKeyboard();
    setState(() {});
    _ctrl.callRefresh();
  }

  closeKeyboard() {
    MyConst.closeKeyboard(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget easy = EasyRefresh.custom(
      controller: _ctrl,
      // enableControlFinishLoad: true,
      // enableControlFinishRefresh: true,
      header: text.isNotEmpty ? MaterialHeader() : null,
      // footer: PhoenixFooter(),
      // onLoad: () {
      //   return;
      // },
      onRefresh: text.isNotEmpty
          ? () async {
              await search();
              return;
            }
          : null,
      slivers: <Widget>[
        // buildAppBar(),
        (list is List && list.length > 0) ? buildBody() : buildEmpty(),
        SliverToBoxAdapter(
          child: Container(
            height: MyConst.gap,
            decoration: BoxDecoration(color: Colors.white),
          ),
        )
      ],
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: closeKeyboard,
        child: easy,
      ),
    );
  }

  buildEmpty() {
    return SliverToBoxAdapter(
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16),
          child:
              Text('暂时还没有数据', style: TextStyle(color: MyConst.lowTextColor))),
    );
  }

  buildAppBar() {
    return AppBar(
      // pinned: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: buildInput(),
          ),
          FlatButton(
            onPressed: () {
              startRefresh();
            },
            child: Text(
              '搜索',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  buildInput() {
    Widget input = TextFormField(
      onChanged: (val) {
        text = val;
      },
      initialValue: text,
      onFieldSubmitted: (val) {
        startRefresh();
      },
    );
    return Container(
      height: kToolbarHeight / 2,
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kToolbarHeight),
          color: Colors.white),
      child: input,
    );
  }

  buildBody() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, idx) {
          Novel item = list[idx];
          double gap = MyConst.gap;

          Widget row = buildItem(item, idx);

          return Container(
            padding: EdgeInsets.only(top: gap, left: gap, right: gap),
            decoration: BoxDecoration(color: Colors.white),
            child: row,
          );
        },
        childCount: list?.length,
      ),
    );
  }

  buildItem(Novel item, int idx) {
    return Row(
      children: <Widget>[
        MyNetImage(item.img),
        Container(
          width: Adapt.px(16),
        ),
        Expanded(
            child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              item.name,
              style: TextStyle(fontSize: Adapt.px(28)),
            ),
            TextLabel(item.cName, bg: Color(0x55999999)),
            TextLabel(
              item.author,
              size: Adapt.px(24),
              padding: EdgeInsets.zero,
              margin: EdgeInsets.only(bottom: Adapt.px(16)),
            ),
            Text(
              item.desc,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: MyConst.mediumTextColor),
            )
          ],
        )),
        Container(
          width: Adapt.px(16),
        ),
        item.isExist == 0
            ? (IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: MyConst.primary,
                ),
                onPressed: () {
                  insert(item, idx);
                }))
            : Text('已添加')
      ],
    );
  }

  insert(Novel item, int idx) async {
    try {
      await novelProvider.insert(item);
      item.isExist = 1;
      list[idx] = item;
      setState(() {});
      BotToast.showSimpleNotification(title: '已成功加入到书架');
      novelStore.getShelf();
    } catch (err) {
      BotToast.showSimpleNotification(title: '可能已存在于书架，添加失败');
    }
  }
}
