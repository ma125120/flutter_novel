import 'package:flutter/material.dart';

import 'package:flutter_novel/store/index.dart';
import 'package:flutter_novel/pages/demo/sqflite.dart';

final counter = Counter();

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // print('init demo');
  }

  // Widget get _renderBody {
  //   return Text('demo');
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Material(
      child: Scaffold(
        appBar: AppBar(title: Text('demo'),),
        body: Column(
          children: <Widget>[
            Observer(builder: (_) => Text('${counter.value}'),),
            RaisedButton(child: Text('增加'), onPressed: counter.increment, color: Theme.of(context).primaryColor, textColor: Colors.white,),
            RaisedButton(child: Text('初始化'), onPressed: counter.init,),
            SqfDemoPage(),
          ],
        ),
      ),
    );
  }
}