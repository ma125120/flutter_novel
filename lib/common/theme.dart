import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/common/const.dart';

class MyThemeData {
  static build(BuildContext context) {
    final primary = MyConst.primary;

    return ThemeData(
        primaryColor: primary,
        backgroundColor: Color(0XFFF9F9F9),
        // platform: TargetPlatform.iOS,
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
        ));
  }
}
