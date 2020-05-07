import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/services.dart';
import 'package:flutter_novel/common/adapt.dart';
import 'package:flutter_novel/common/http/API.dart';
import 'package:flutter_novel/components/index.dart';
import 'package:flutter_novel/data/article.dart';
import 'package:flutter_novel/data/novel.dart';
import 'package:flutter_novel/models/article.dart';
import 'package:flutter_novel/models/novel.dart';
import 'package:flutter_novel/pages/reader/agent.dart';
import 'package:flutter_novel/pages/reader/drawer.dart';
import 'package:flutter_novel/pages/reader/reader_config.dart';
import 'package:flutter_novel/pages/reader/reader_menu.dart';
import 'package:flutter_novel/pages/reader/reader_utils.dart';
import 'package:flutter_novel/pages/reader/reader_view.dart';
import 'package:flutter_novel/store/article.dart';
import 'package:wakelock/wakelock.dart';

enum PageJumpType { stay, firstPage, lastPage }

class ReaderPage extends StatefulWidget {
  ReaderPage({this.novel});
  final Novel novel;

  static handler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        final Novel novel = ModalRoute.of(context).settings.arguments;

        return ReaderPage(
          novel: novel,
        );
      },
    );
  }

  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Novel info;
  int pageIndex = 0;
  bool isMenuVisiable = false;
  PageController pageController = PageController(
    keepPage: false,
  );
  bool isLoading = false;

  double topSafeHeight = Adapt.paddingTop();

  Article prevArticle;
  Article currentArticle;
  Article nextArticle;
  Timer timer;

  List<Article> list = [];

  @override
  void initState() {
    super.initState();
    ReaderConfig.init();
    setup();
    init();
  }

  init() async {
    // withLoading(() async {
    Novel novel = widget.novel;
    info = novel;
    List<Article> _list = await articleStore.getArticleAllInfo(novel);
    list = _list;

    await getAllArticle();
    setState(() {});
    resetContent(false);
    BotToast.closeAllLoading();
    // });
  }

  getAllArticle([String id]) async {
    String cid = id ?? info.currentChapterId;

    String dbName = info.id;
    if (cid == null) {
      cid = list.first?.id;
      info.currentChapterId = cid;
      novelProvider.update(info);
    }

    currentArticle = await getArticle(dbName, cid);

    if (currentArticle != null) {
      prevArticle = await getArticle(dbName, currentArticle.prevId);
      nextArticle = await getArticle(dbName, currentArticle.nextId);
    }
  }

  getArticle(String dbName, String chapterId) async {
    if (chapterId == null) return null;

    Article article = await articleProvider.getArticle(dbName, chapterId);

    if (article != null) {
      article = await getArticlePageOffsets(article);
      list[article.index] = article;
    }

    return article;
  }

  getArticlePageOffsets(Article article) async {
    var contentHeight = Adapt.height -
        // topSafeHeight -
        ReaderUtils.topOffset -
        Adapt.paddingBottom() -
        ReaderUtils.bottomOffset -
        20;
    var contentWidth =
        Adapt.width - ReaderUtils.leftOffset - ReaderUtils.rightOffset;
    article.pageOffsets = await ReaderPageAgent.getPageOffsets(
        article.content, contentHeight, contentWidth, ReaderConfig.fontSize);
    article.index = list.indexWhere((v) => v.id == article.id);
    return article;
  }

  void setup() async {
    await SystemChrome.setEnabledSystemUIOverlays([]);
    // 不延迟的话，安卓获取到的topSafeHeight是错的。
    await Future.delayed(const Duration(milliseconds: 100), () {});
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  @override
  void dispose() {
    pageController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentArticle == null || list == null) {
      return Scaffold(
        body: Container(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Container(
                  width: 16,
                ),
                Text(
                  '加载中...',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          color: Color(ReaderConfig.bgColor),
        ),
      );
    }

    return WillPopScope(
      onWillPop: beforeUpload,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(ReaderConfig.bgColor),
        drawer: buildDrawer(),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Color(ReaderConfig.bgColor),
                )),
            buildPageView(),
            buildMenu(),
          ],
        ),
      ),
    );
  }

  Future<bool> beforeUpload() async {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    Wakelock.disable();
    return true;
  }

  buildMenu() {
    if (!isMenuVisiable) {
      return Container();
    }

    return ReaderMenu(
      name: currentArticle.name,
      chapters: list,
      articleIndex: currentArticle.index,
      onTap: hideMenu,
      refreshUI: () {
        setState(() {});
      },
      openDrawer: () {
        _scaffoldKey.currentState.openDrawer();
      },
      onInitCb: () {
        BotToast.showCustomLoading(
            toastBuilder: (cancelFunc) => MyCustomLoadingDialog());
        init();
      },
      onRefresh: refreshArticle,
      onPreviousArticle: () async {
        withLoading(() async {
          info.currentPageIndex = 0;
          nextArticle = currentArticle;
          currentArticle = prevArticle;
          prevArticle = await getArticle(info.id, currentArticle.prevId);
          setState(() {});
          resetContent();
        });
      },
      onNextArticle: () async {
        withLoading(() async {
          info.currentPageIndex = 0;
          prevArticle = currentArticle;
          currentArticle = nextArticle;
          nextArticle = await getArticle(info.id, currentArticle.nextId);
          setState(() {});
          resetContent();
        });
      },
      onToggleChapter: (Article chapter) async {
        withLoading(() async {
          info.currentPageIndex = 0;
          await getAllArticle(chapter.id);
          setState(() {});
          resetContent();
        });
      },
    );
  }

  withLoading(cb) async {
    BotToast.showCustomLoading(
        toastBuilder: (cancelFunc) => MyCustomLoadingDialog());
    await cb();
    BotToast.closeAllLoading();
  }

  resetContent([needHideMenu = false]) async {
    Timer(Duration(milliseconds: 20), () {
      try {
        pageController?.jumpToPage(
            (info.currentPageIndex ?? 0) + (prevArticle?.pageCount ?? 0));
      } catch (err) {
        print(err);
      }

      if (needHideMenu) {
        hideMenu();
      }
    });
  }

  hideMenu() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    setState(() {
      this.isMenuVisiable = false;
    });
  }

  buildPageView() {
    if (currentArticle == null) {
      return Container(
        color: Color(ReaderConfig.bgColor),
      );
    }

    int itemCount = (prevArticle != null ? prevArticle.pageCount : 0) +
        currentArticle.pageCount +
        (nextArticle != null ? nextArticle.pageCount : 0);

    return PageView.builder(
      physics: BouncingScrollPhysics(),
      controller: pageController,
      itemCount: itemCount,
      itemBuilder: buildPage,
      onPageChanged: onPageChanged,
    );
  }

  onPageChanged(int index) async {
    int page = index - (prevArticle != null ? prevArticle.pageCount : 0);

    if (page < currentArticle.pageCount && page >= 0) {
      setState(() {
        pageIndex = page;
      });
      info.currentPageIndex = pageIndex;
    } else if (page >= currentArticle.pageCount - 1) {
      // 下一章
      prevArticle = currentArticle;
      currentArticle = nextArticle;
      nextArticle = await getArticle(info.id, currentArticle.nextId);
      info.currentPageIndex = 0;
      resetContent();
    } else if (page < 0) {
      nextArticle = currentArticle;
      currentArticle = prevArticle;
      prevArticle = await getArticle(info.id, currentArticle.prevId);
      info.currentPageIndex = currentArticle.pageCount - 1;
      resetContent();
    }

    info.currentChapterId = currentArticle.id;
    novelProvider.update(info);
  }

  previousPage() {
    if (pageIndex == 0 && currentArticle.prevId == null) {
      BotToast.showText(text: '已经是第一页了');
      return;
    }

    pageController.previousPage(
        duration: Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  nextPage() {
    if (pageIndex >= currentArticle.pageCount - 1) {
      if (currentArticle.nextId == null) {
        BotToast.showText(text: '已经是最后一页了');
        return;
      }
    }
    pageController.nextPage(
        duration: Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  Widget buildPage(BuildContext context, int index) {
    var page = index - (prevArticle != null ? prevArticle.pageCount : 0);
    var article = currentArticle;

    if (page >= this.currentArticle.pageCount) {
      // 到达下一章了
      article = nextArticle;
      page = 0;
    } else if (page < 0) {
      // 到达上一章了
      article = prevArticle;
      page = prevArticle.pageCount - 1;
    } else {
      article = this.currentArticle;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (TapUpDetails details) {
        onTap(details.globalPosition);
      },
      child: ReaderView(
          article: article, page: page, topSafeHeight: topSafeHeight),
    );
  }

  onTap(Offset position) async {
    double xRate = position.dx / Adapt.width;

    if (xRate > 0.33 && xRate < 0.66) {
      SystemChrome.setEnabledSystemUIOverlays(
          [SystemUiOverlay.top, SystemUiOverlay.bottom]);
      setState(() {
        isMenuVisiable = true;
      });
    } else if (xRate >= 0.66) {
      nextPage();
    } else {
      previousPage();
    }
  }

  buildDrawer() {
    return ReaderDrawer(
        id: currentArticle.id,
        list: list,
        index: currentArticle.index,
        name: widget.novel.name,
        onSelect: (Article item) async {
          withLoading(() async {
            await getAllArticle(item.id);
            info.currentPageIndex = 0;
            info.currentChapterId = item.id;
            novelProvider.update(info);
            resetContent();
            Navigator.pop(context);
            hideMenu();
          });
        });
  }

  refreshArticle() async {
    withLoading(() async {
      currentArticle = await API.getArticle(info.id, currentArticle.id);
      if (currentArticle != null) {
        currentArticle = await getArticlePageOffsets(currentArticle);
      }
      await articleProvider.updateChapter(info.id, currentArticle);
      setState(() {});
      hideMenu();
    });
  }
}
