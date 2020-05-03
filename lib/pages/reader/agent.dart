import 'package:flutter/material.dart';
// import 'package:flutter_novel/common/adapt.dart';
import 'package:flutter_novel/pages/reader/reader_config.dart';
// import 'package:flutter_novel/pages/reader/reader_utils.dart';

class ReaderPageAgent {
  static Future<List<Map<String, int>>> getPageOffsets(
      String content, double height, double width, double fontSize) async {
    String tempStr = content;
    double lineHeight = ReaderConfig.lineHeight;
    // DateTime now = DateTime.now();
    List<Map<String, int>> pageConfig = [];
    int last = 0;

    await Future(() async {
      while (true) {
        bool isbreak = await Future(() {
          Map<String, int> offset = {};
          offset['start'] = last;
          TextPainter textPainter = TextPainter(
            textDirection: TextDirection.ltr,
          );
          textPainter.text = TextSpan(
              text: tempStr,
              style: TextStyle(
                fontSize: fontSize,
                height: lineHeight,
              ));
          textPainter.layout(maxWidth: width);
          var end = textPainter
              .getPositionForOffset(Offset(width, height - fontSize))
              .offset;

          if (end == 0) {
            return true;
          }
          tempStr = tempStr.substring(end, tempStr.length);
          offset['end'] = last + end;
          last = last + end;
          pageConfig.add(offset);

          return false;
        });
        if (isbreak) break;
      }
    });
    // print(DateTime.now().difference(now).inMilliseconds);
    return pageConfig;
  }
}
