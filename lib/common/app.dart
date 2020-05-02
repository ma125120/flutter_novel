import 'package:flutter_novel/router/index.dart';
import 'package:flutter/material.dart';

class App {
  static MyRouter router;
  static pop(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}