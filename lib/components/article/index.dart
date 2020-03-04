import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_base/common/adapt.dart';

class MyTitle extends StatelessWidget {
  final String text;

  MyTitle(this.text, );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold),),
    );
  }
}

ImageProvider myImage(String url) {
  return CachedNetworkImageProvider(url,);
}

class MyAvatar extends StatelessWidget {
  final String url;
  final double radius;
  MyAvatar(this.url, { this.radius = 54.0 });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: myImage(url),
      radius: Adapt.px(radius),
    );
  }
}

class ScrollHeader extends StatelessWidget {
  final bool isShowTitle;
  final Color bgColor;
  final double topHeight;
  final Widget child;
  final Widget title;
  final ImageProvider image;
  final MainAxisAlignment mainAxisAlignment;
  final BuildContext context;
  final double opacity;

  ScrollHeader({
    this.isShowTitle = false,
    @required this.topHeight,
    @required this.context,
    @required this.child,
    this.title,
    this.image,
    this.mainAxisAlignment = MainAxisAlignment.end,
    this.bgColor = const Color.fromRGBO(0, 0, 0, .6),
    this.opacity = 0.0,
  }): assert(child != null);

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      // collapseMode: CollapseMode.pin,
      title: isShowTitle ? Opacity(child: title, opacity: opacity,) : null,
      background: Container(
        height: topHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: image,
          ),
        ),
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          children: <Widget>[
            Container(
              color: bgColor,
              width: MediaQuery.of(context).size.width,
              height: topHeight,
              child: child,
            )
          ],
        ),
      ),
    );
  }
}

class MyFadeHeader extends StatelessWidget {
  final Widget child;
  final double opacity;
  final bool show;

  MyFadeHeader({
    @required this.child,
    this.opacity = 0.0,
    this.show = false,
  }): assert(opacity >= 0.0 && opacity <= 1.0);

  @override
  Widget build(BuildContext context) {
    return show ? Opacity(child: child, opacity: opacity,) : Text('');
  }
}