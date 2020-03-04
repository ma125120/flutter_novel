import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
// import 'package:flutter_base/pages/webview.dart';
import 'package:flutter_base/pages/tabs/home.dart';
import 'package:flutter_base/pages/tabs/setting.dart';

class IndexPage extends StatefulWidget {
  static handler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        return IndexPage();
      },
    );
  }

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  static int index = 0;

  final PageController _pageController = PageController();
  
  final List<Widget> pages = [
    HomePage(),
    SettingPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: PageView.builder(
          itemBuilder: (context, index) {
            return SafeArea(child: pages[index],);
          },
          itemCount: pages.length,
          controller: _pageController,
          onPageChanged: (idx) {
            setState(() {
              index = idx;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          onTap: (idx) {
            _pageController.animateToPage(idx, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('主页'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('设置'),
            ),
          ]
        ),
      )
    );
  }
}