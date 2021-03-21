import 'package:flutter/material.dart';
import 'package:flutter_novel/common/adapt.dart';
// import 'package:flutter_novel/common/const.dart';
import 'package:flutter_novel/models/article.dart';
import 'package:flutter_novel/pages/reader/reader_config.dart';
import 'package:flutter_novel/pages/reader/reader_utils.dart';
import 'package:intl/intl.dart';

import 'battery_view.dart';

class ReaderOverlayer extends StatelessWidget {
  final Article article;
  final int page;
  final double topSafeHeight;

  ReaderOverlayer({this.article, this.page, this.topSafeHeight});

  get textStyle => TextStyle(
        fontSize: 12,
        color: Color(ReaderConfig.color),
      );

  @override
  Widget build(BuildContext context) {
    var format = DateFormat('HH:mm');
    var time = format.format(DateTime.now());

    return Container(
      padding: EdgeInsets.fromLTRB(ReaderUtils.leftOffset, 10,
          ReaderUtils.rightOffset, 10 + Adapt.paddingBottom()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(article.name, style: textStyle),
          Expanded(child: Container()),
          Row(
            children: <Widget>[
              BatteryView(),
              SizedBox(width: 10),
              Text(time, style: textStyle),
              Expanded(child: Container()),
              Text('第${page + 1}页/共${article.pageCount}页', style: textStyle),
            ],
          ),
        ],
      ),
    );
  }
}
