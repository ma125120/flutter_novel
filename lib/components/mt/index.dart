import 'package:flutter/material.dart';

class MyInk extends StatelessWidget {
  final Widget child;
  final Function() onTap;
  final VoidCallback onLongPress;
  MyInk({
    this.child,
    this.onTap,
    this.onLongPress,
  }) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        child: child,
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}

class FixedStack extends StatelessWidget {
  final Widget body;
  final List<Widget> children;
  FixedStack({this.body, this.children = const []}) : assert(body != null);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        body,
        ...children,
      ],
    );
  }
}
