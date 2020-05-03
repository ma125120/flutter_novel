import 'package:shared_preferences/shared_preferences.dart';

class ReaderConfig {
  static SharedPreferences ref;
  static init() async {
    ref = await SharedPreferences.getInstance();
  }

  static ReaderConfig _instance;
  static ReaderConfig get instance {
    if (_instance == null) {
      _instance = ReaderConfig();
    }

    return _instance;
  }

  static double get fontSize => ref?.getDouble('fontSize') ?? 18.0;
  static double get lineHeight => ref?.getDouble('lineHeight') ?? 1.5;
  static int get bgColor => ref?.getInt('bgColor') ?? 0xFFe3c394;
  static int get color => ref?.getInt('color') ?? 0xFF000000;

  static changeColor(int color) {
    ref.setInt('color', color);
  }

  static changeBgColor(int color) {
    ref.setInt('bgColor', color);
  }

  static changeFontSize(double num) {
    if (fontSize > 10 && fontSize < 50) {
      ref.setDouble('fontSize', fontSize + num);
    }
  }

  static changeLineHeight(double num) {
    if (lineHeight > 1 && lineHeight < 5) {
      ref.setDouble('lineHeight', lineHeight + num);
    }
  }
}
