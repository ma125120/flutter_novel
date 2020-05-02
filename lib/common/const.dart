import 'package:flutter/cupertino.dart';
import 'package:flutter_novel/common/adapt.dart';

class MyConst {
  static Color primary = Color(0xFF7964E3);
  static const highTextColor = Color(0xDD000000);
  static const mediumTextColor = Color(0x99000000);
  static const lowTextColor = Color(0x60000000);
  static const grey = Color(0x61000000);
  static const divideColor = Color(0xFFF0F0F0);

  static const drawerBgColor = Color(0xFFe8e0dd);
  static const readerBg = Color(0xFFe3c394);
  static Color golden = Color(0xff8B7961);

  static double gap = Adapt.px(24);

  static String dbPath = '_novel';

  static closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
