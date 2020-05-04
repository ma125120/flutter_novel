import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_novel/common/theme.dart';
import 'package:flutter_novel/data/novel.dart';
import 'dart:io';
import 'router/index.dart';
import 'router/watch.dart';
import 'package:bot_toast/bot_toast.dart';
import 'common/http/index.dart';
import 'common/app.dart';

void main() {
  runApp(MyApp());
  // 如果是Android设备，就执行下面的代码实现沉浸式状态栏
  if (Platform.isAndroid) {
    // 设置系统的沉浸式UI效果--把状态栏变成透明
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    // 应用这个效果
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatefulWidget {
  MyApp() {
    final router = MyRouter();
    Routes.configRoutes(router);

    App.router = router;
    // App.

    API.init();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    novelProvider.getShelf();
  }

  @override
  Widget build(BuildContext context) {
    Widget app = MaterialApp(
      navigatorObservers: [
        BotToastNavigatorObserver(),
        MyWatchRoute(),
      ],
      onGenerateRoute: App.router.generator,
      initialRoute: Routes.index,
      // title: 'Flutter Demo',
      theme: MyThemeData.build(context),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
    );

    // return app;
    return BotToastInit(
      child: app,
    );
  }
}
