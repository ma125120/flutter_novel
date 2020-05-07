import 'package:json_annotation/json_annotation.dart';

part 'novel.g.dart';

@JsonSerializable()
class Novel {
  Novel();

  @JsonKey(name: 'Id')
  String id;

  @JsonKey(name: 'Name')
  String name;
  @JsonKey(name: 'Author')
  String author;
  @JsonKey(name: 'Img')
  String img;
  @JsonKey(name: 'Desc')
  String desc;
  @JsonKey(name: 'BookStatus')
  String bookStatus;
  @JsonKey(name: 'LastChapterId')
  String lastChapterId;
  @JsonKey(name: 'LastChapter')
  String lastChapter;
  @JsonKey(name: 'CName')
  String cName;
  @JsonKey(name: 'UpdateTime')
  String updateTime;

  int isExist = 0;

  // 上次存储的最后一章
  String storeLastChapterId;

  // 正在阅读的章节id
  String currentChapterId;

  // 正在阅读章节的页数
  int currentPageIndex = 0;

  factory Novel.fromJson(Map<String, dynamic> json) => _$NovelFromJson(json);
  Map<String, dynamic> toJson() => _$NovelToJson(this);

  bool get canUpdate =>
      storeLastChapterId != null &&
      int.parse(storeLastChapterId) < int.parse(lastChapterId);
}
