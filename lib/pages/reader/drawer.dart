import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/common/adapt.dart';
import 'package:flutter_novel/common/const.dart';
import 'package:flutter_novel/components/index.dart';
import 'package:flutter_novel/models/article.dart';
import 'package:flutter_novel/store/article.dart';
import 'package:flutter_novel/store/index.dart';

class ReaderDrawer extends StatefulWidget {
  final String id;
  final int index;
  final String name;
  final void Function(Article item) onSelect;

  ReaderDrawer({
    this.name,
    this.onSelect,
    this.id,
    this.index,
  });

  @override
  _ReaderDrawerState createState() => _ReaderDrawerState();
}

class _ReaderDrawerState extends State<ReaderDrawer> {
  ScrollController _scrollController;
  @override
  initState() {
    super.initState();
    double itemHeight = Adapt.px(24 * 2 + 32);
    double offset = itemHeight * (widget.index);
    _scrollController = ScrollController(initialScrollOffset: offset);
  }

  @override
  dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  toNow() {
    double itemHeight = Adapt.px(24 * 2 + 32);
    double offset = itemHeight * (widget.index);
    _scrollController.jumpTo(offset);
    // _scrollCtrl.animateTo(offset,
    //     duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  buildList() {
    return Observer(
      builder: (_) {
        List<Article> list = articleStore.list;
        return ListView.builder(
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
                      size: Adapt.px(28),
                      padding: EdgeInsets.symmetric(
                          vertical: Adapt.px(24), horizontal: Adapt.px(16)),
                      margin: EdgeInsets.all(0),
                    ),
                  ),
                  if (item.content != null)
                    TextLabel(
                      '已缓存',
                      size: Adapt.px(24),
                      color: MyConst.lowTextColor,
                      padding: EdgeInsets.symmetric(
                          vertical: Adapt.px(24), horizontal: Adapt.px(16)),
                      margin: EdgeInsets.all(0),
                    )
                ],
              ),
              onTap: () {
                widget.onSelect(item);
              },
            );
          },
          itemCount: list.length,
        );
      },
    );
  }

  buildHeader(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.arrow_back_ios, color: MyConst.lowTextColor),
            onPressed: () {
              Navigator.pop(context);
            }),
        Expanded(
            child: Text(
          widget.name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: Adapt.px(32)),
        )),
        IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: MyConst.lowTextColor,
              size: 0,
            ),
            onPressed: () {}),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget listview = buildList();

    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: Adapt.paddingTop()),
          width: Adapt.px(600),
          child: Column(
            children: <Widget>[
              buildHeader(context),
              Expanded(child: listview),
            ],
          ),
          color: MyConst.drawerBgColor,
        ),
        Positioned(
          child: MyInk(
            child: buildNow(),
            onTap: toNow,
          ),
          right: Adapt.px(24),
          bottom: Adapt.px(24),
        )
      ],
    );
  }

  buildNow() {
    return ClipOval(
      child: Container(
        color: Colors.white,
        width: Adapt.px(108),
        height: Adapt.px(108),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.place, color: Colors.orange),
            Container(
              height: Adapt.px(8),
            ),
            Text(
              '当前',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
