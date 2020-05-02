import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/services.dart';
import 'package:flutter_novel/common/adapt.dart';
import 'package:flutter_novel/common/const.dart';
import 'package:flutter_novel/common/http/API.dart';
import 'package:flutter_novel/components/article/index.dart';
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
import 'package:flutter_novel/store/index.dart';

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

  List<Article> list = [];

  @override
  void initState() {
    super.initState();
    ReaderConfig.init();
    setup();
    init();
  }

  init() async {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      BotToast.showLoading();
    });
    // BotToast.showLoading();
    Novel novel = widget.novel;
    info = novel;
    List<Article> _list = await articleStore.getArticleAllInfo(novel);
    list = _list;

    await getAllArticle();
    setState(() {});
    resetContent(false);
    BotToast.closeAllLoading();
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
      article = getArticlePageOffsets(article);
    }

    return article;
  }

  getArticlePageOffsets(Article article) {
    var contentHeight = Adapt.height -
        // topSafeHeight -
        ReaderUtils.topOffset -
        Adapt.paddingBottom() -
        ReaderUtils.bottomOffset -
        20;
    var contentWidth = Adapt.width - 15 - 10;
    article.pageOffsets = ReaderPageAgent.getPageOffsets(
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentArticle == null || list == null) {
      return Scaffold(
        body: Container(
          color: MyConst.readerBg,
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyConst.readerBg,
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
                color: MyConst.readerBg,
              )),
          buildPageView(),
          buildMenu(),
        ],
      ),
    );
  }

  buildMenu() {
    if (!isMenuVisiable) {
      return Container();
    }

    return ReaderMenu(
      chapters: list,
      articleIndex: currentArticle.index,
      onTap: hideMenu,
      openDrawer: () {
        _scaffoldKey.currentState.openDrawer();
      },
      onInitCb: () {
        init();
      },
      onRefresh: refreshArticle,
      onPreviousArticle: () async {
        info.currentPageIndex = 0;
        await getAllArticle(currentArticle.prevId);
        setState(() {});
        resetContent();
        // resetContent(currentArticle.prevId, PageJumpType.firstPage);
      },
      onNextArticle: () async {
        info.currentPageIndex = 0;
        await getAllArticle(currentArticle.nextId);
        setState(() {});
        resetContent();
        // resetContent(currentArticle.nextId, PageJumpType.firstPage);
      },
      onToggleChapter: (Article chapter) async {
        info.currentPageIndex = 0;
        await getAllArticle(chapter.id);
        setState(() {});
        resetContent();
        // resetContent(chapter.id, PageJumpType.firstPage);
      },
    );
  }

  resetContent([needHideMenu = true]) async {
    Timer(Duration(milliseconds: 20), () {
      pageController.jumpToPage(
          (info.currentPageIndex ?? 0) + (prevArticle?.pageCount ?? 0));
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
        color: MyConst.readerBg,
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
      await getAllArticle(nextArticle.id);
      info.currentPageIndex = 0;
      resetContent();
    } else if (page < 0) {
      await getAllArticle(prevArticle.id);
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
        index: currentArticle.index,
        name: widget.novel.name,
        onSelect: (Article item) async {
          await getAllArticle(item.id);
          info.currentPageIndex = 0;
          resetContent();
          Navigator.pop(context);
          hideMenu();
        });
  }

  refreshArticle() async {
    currentArticle = await API.getArticle(info.id, currentArticle.id);
    if (currentArticle != null) {
      currentArticle = getArticlePageOffsets(currentArticle);
    }
    await articleProvider.updateChapter(info.id, currentArticle);
    setState(() {});
    hideMenu();
  }
}