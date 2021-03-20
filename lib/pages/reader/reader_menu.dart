import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/common/adapt.dart';
import 'package:flutter_novel/common/const.dart';
import 'package:flutter_novel/components/index.dart';
import 'dart:async';

import 'package:flutter_novel/models/article.dart';
import 'package:flutter_novel/pages/reader/reader_config.dart';
// import 'package:flutter_novel/pages/reader/reader_utils.dart';
import 'package:wakelock/wakelock.dart';

const black = 0xFF121212;
const white = 0xFFCCCCCC;

class ReaderMenu extends StatefulWidget {
  final List<Article> chapters;
  final int articleIndex;
  final String name;

  final VoidCallback onTap;
  final VoidCallback openDrawer;
  final VoidCallback onRefresh;
  final VoidCallback onInitCb;

  final VoidCallback onPreviousArticle;
  final VoidCallback onNextArticle;
  final VoidCallback refreshUI;
  final void Function(Article chapter) onToggleChapter;

  ReaderMenu(
      {this.chapters,
      this.articleIndex,
      this.onTap,
      this.name,
      this.onPreviousArticle,
      this.onNextArticle,
      this.openDrawer,
      this.onRefresh,
      this.onInitCb,
      this.refreshUI,
      this.onToggleChapter});

  @override
  _ReaderMenuState createState() => _ReaderMenuState();
}

class _ReaderMenuState extends State<ReaderMenu>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  bool isDark = false;

  double progressValue;
  bool isTipVisible = false;
  bool isShowSetting = false;
  bool isLight = true;
  List<int> bgColors = [
    0xFFe3c394,
    0xFFd9caac,
    0xFFE3EDCD,
    black,
    0xFF333333,
    0xFF666666,
    0xFFe8e0c2,
    0xFFCCE8CF,
    0xFFbeb1c2,
    0xFFd1d1d1,
    0xFFbbc9d3,
    0xFFe0d1ca
  ];
  List<int> colors = [
    0Xff000000,
    0xFF333333,
    0xFF666666,
    0xFF999999,
    white,
    0xFFFFFFFF,
    0xDDffffff,
    0x99ffffff,
    0x60ffffff,
  ];

  @override
  initState() {
    super.initState();

    progressValue =
        this.widget.articleIndex / (this.widget.chapters.length - 1);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animation.addListener(() {
      setState(() {});
    });
    animationController.forward();

    init();
  }

  init() async {
    isLight = await Wakelock.isEnabled;
    setState(() {});
  }

  @override
  void didUpdateWidget(ReaderMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    progressValue =
        this.widget.articleIndex / (this.widget.chapters.length - 1);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  hide() {
    animationController.reverse();
    Timer(Duration(milliseconds: 200), () {
      this.widget.onTap();
    });
    setState(() {
      isTipVisible = false;
    });
  }

  buildTopView(BuildContext context) {
    return Positioned(
      top: -Adapt.navbarHeight * (1 - animation.value),
      left: 0,
      right: 0,
      child: AppBar(
        title: Text(
          widget.name ?? '',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              '${isLight ? '取消' : '保持'}常亮',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              bool on = !isLight;
              Wakelock.toggle(on: on);
              isLight = on;
              setState(() {});
            },
          ),
          FlatButton(
            child: Text(
              '刷新',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: widget.onRefresh,
          )
        ],
      ),
    );
  }

  int currentArticleIndex() {
    return ((this.widget.chapters.length - 1) * progressValue).toInt();
  }

  buildProgressTipView() {
    if (!isTipVisible) {
      return Container();
    }

    Article chapter = this.widget.chapters[currentArticleIndex()];
    int index = this.widget.chapters.indexWhere((v) => v.id == chapter.id);
    double percentage = index / (this.widget.chapters.length - 1) * 100;

    return Container(
      decoration: BoxDecoration(
          color: Color(0xff00C88D), borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(chapter.name,
              style: TextStyle(color: Colors.white, fontSize: 16)),
          Text('${percentage.toStringAsFixed(1)}%',
              style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  previousArticle() {
    if (this.widget.articleIndex == 0) {
      BotToast.showText(text: '已经是第一章了');
      return;
    }
    this.widget.onPreviousArticle();
    setState(() {
      isTipVisible = true;
    });
  }

  nextArticle() {
    if (this.widget.articleIndex == this.widget.chapters.length - 1) {
      BotToast.showText(text: '已经是最后一章了');
      return;
    }
    this.widget.onNextArticle();
    setState(() {
      isTipVisible = true;
    });
  }

  buildProgressView() {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: previousArticle,
          ),
          Expanded(
            child: Slider(
              value: progressValue,
              onChanged: (double value) {
                setState(() {
                  isTipVisible = true;
                  progressValue = value;
                });
              },
              onChangeEnd: (double value) {
                Article chapter = this.widget.chapters[currentArticleIndex()];
                this.widget.onToggleChapter(chapter);
              },
              activeColor: MyConst.primary,
              inactiveColor: Colors.white,
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: nextArticle,
          ),
        ],
      ),
    );
  }

  bool isDarkMode(BuildContext context) {
    return Theme.of(context).colorScheme.brightness == Brightness.dark;
  }

  buildBottomView() {
    return Positioned(
      bottom: -(Adapt.paddingBottom() + 110) * (1 - animation.value),
      left: 0,
      right: 0,
      child: isShowSetting
          ? buildSetting()
          : Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 8, bottom: 8),
                      child: MyInk(
                        child: CircleAvatar(
                          child: Icon(isDark
                              ? Icons.lightbulb
                              : Icons.nightlight_round),
                          backgroundColor: isDark ? Colors.black : Colors.white,
                        ),
                        onTap: () {
                          bool _isDark = false;
                          if (ReaderConfig.bgColor == black) {
                            ReaderConfig.changeBgColor(bgColors[0]);
                            ReaderConfig.changeColor(colors[0]);
                          } else {
                            ReaderConfig.changeBgColor(black);
                            ReaderConfig.changeColor(white);
                            _isDark = true;
                          }
                          setState(() {
                            isDark = _isDark;
                          });
                          widget.refreshUI();
                        },
                      ),
                    )
                  ],
                ),
                buildProgressTipView(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  padding: EdgeInsets.only(bottom: Adapt.paddingBottom()),
                  child: Column(
                    children: <Widget>[
                      buildProgressView(),
                      buildBottomMenus(),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  openSetting() {
    isShowSetting = true;
    setState(() {});
  }

  buildSetting() {
    Color color = Colors.white;
    TextStyle textStyle = TextStyle(
      color: color,
      fontSize: 16,
    );
    double gap = MyConst.gap;

    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Color(0xff1f1f1f),
          ),
          padding: EdgeInsets.only(
            bottom: Adapt.paddingBottom() + gap,
            top: gap,
            left: gap,
            right: gap,
          ),
          child: Column(
            children: <Widget>[
              _renderColorArea(
                  list: bgColors,
                  title: '背景：',
                  value: ReaderConfig.bgColor,
                  onChange: (color) {
                    ReaderConfig.changeBgColor(color);
                    widget.refreshUI();
                  }),
              _renderColorArea(
                  list: colors,
                  title: '字体：',
                  value: ReaderConfig.color,
                  onChange: (color) {
                    ReaderConfig.changeColor(color);
                    widget.refreshUI();
                  }),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _renderInkItem(
                      left: Text(
                        'Aa-',
                        textAlign: TextAlign.center,
                        style: textStyle,
                      ),
                      leftCb: () {
                        changeAndRefresh(() {
                          ReaderConfig.changeFontSize(-1);
                        });
                      },
                      right: Text('Aa+',
                          textAlign: TextAlign.center, style: textStyle),
                      rightCb: () {
                        changeAndRefresh(() {
                          ReaderConfig.changeFontSize(1);
                        });
                      },
                      value: ReaderConfig.fontSize.toString(),
                    ),
                  ),
                  Container(
                    width: 24,
                  ),
                  Expanded(
                    child: _renderInkItem(
                      left: Icon(
                        Icons.unfold_less,
                        color: color,
                      ),
                      leftCb: () {
                        changeAndRefresh(() {
                          ReaderConfig.changeLineHeight(-0.1);
                        });
                      },
                      right: Icon(
                        Icons.unfold_more,
                        color: color,
                      ),
                      rightCb: () {
                        changeAndRefresh(() {
                          ReaderConfig.changeLineHeight(0.1);
                        });
                      },
                      value: ReaderConfig.lineHeight.toStringAsFixed(1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  _renderColorArea({
    List<int> list,
    int value,
    onChange,
    String title,
  }) {
    return Container(
      width: Adapt.width,
      height: 60,
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: <Widget>[
          Text(
            title ?? '背景：',
            style: TextStyle(color: Colors.white),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              primary: false,
              children: list.map((v) {
                return MyInk(
                  onTap: () {
                    onChange(v);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    width: 60,
                    height: 60,
                    child: Center(
                      child: Text(
                        v == value ? '√' : '',
                        style: TextStyle(color: Colors.red, fontSize: 32),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Color(v),
                        borderRadius: BorderRadius.circular(80)),
                    // color: Color(v),
                  ),
                );
              }).toList(),
              scrollDirection: Axis.horizontal,
            ),
          )
        ],
      ),
    );
  }

  _renderInkItem({
    Widget left,
    leftCb,
    rightCb,
    Widget right,
    String value,
  }) {
    BorderSide side = BorderSide(width: 1, color: Color(0xFF999999));
    Color color = Colors.white;

    return Container(
      height: 36,
      child: Row(
        children: <Widget>[
          _renderInkButton(left, leftCb),
          Container(
            height: 36,
            child: Center(
              child: Text(
                value ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(color: color),
              ),
            ),
            decoration: BoxDecoration(
              border: Border(left: side, right: side),
            ),
          ),
          _renderInkButton(right, rightCb),
        ]
            .map((v) => Expanded(
                  child: v,
                ))
            .toList(),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Color(0xFF999999),
            width: 1,
          )),
    );
  }

  _renderInkButton(
    Widget child,
    cb,
  ) {
    return MyInk(
      onTap: cb,
      child: Container(
        child: child,
        // padding: EdgeInsets.all(Adapt.px(12)),
      ),
    );
  }

  changeAndRefresh(cb) async {
    await cb();
    widget.onInitCb();
  }

  buildBottomMenus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        buildBottomItem('目录', Icons.list),
        buildBottomItem('设置', Icons.settings, openSetting),
        // buildBottomItem('字体大小', Icons.text_fields),
        // buildBottomItem(
        //   '行高',
        //   Icons.format_line_spacing,
        // ),
      ]
          .map((v) => Expanded(
                child: v,
              ))
          .toList(),
    );
  }

  buildBottomItem(String title, IconData icon, [cb]) {
    return MyInk(
      onTap: cb ?? widget.openDrawer,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 7),
        child: Column(
          children: <Widget>[
            Icon(
              icon ?? Icons.list,
              color: Colors.white,
            ),
            // Image.asset(icon),
            SizedBox(height: 5),
            Text(title,
                style: TextStyle(fontSize: Adapt.px(24), color: Colors.white)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTapDown: (_) {
              hide();
            },
            child: Container(color: Colors.transparent),
          ),
          buildTopView(context),
          buildBottomView(),
        ],
      ),
    );
  }
}
