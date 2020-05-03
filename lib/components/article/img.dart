import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_novel/common/adapt.dart';

class MyNetImage extends StatelessWidget {
  MyNetImage(this.src, {this.width});

  final String src;
  final double width;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: src,
      width: width ?? Adapt.px(160),
    );
  }
}
