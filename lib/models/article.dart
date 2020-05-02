import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

@JsonSerializable()
class Article {
  Article();

  String id;

  String name;

  String volumeName;

  String prevId;

  String nextId;

  String content;

  @JsonKey(ignore: true)
  int index = 0;

  @JsonKey(ignore: true)
  List<Map<String, int>> pageOffsets;

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  String stringAtPageIndex(int index) {
    var offset = pageOffsets[index];
    return this.content.substring(offset['start'], offset['end']);
  }

  int get pageCount {
    return pageOffsets?.length;
  }
}
