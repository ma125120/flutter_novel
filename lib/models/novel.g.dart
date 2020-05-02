// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Novel _$NovelFromJson(Map<String, dynamic> json) {
  return Novel()
    ..id = json['Id'] as String
    ..name = json['Name'] as String
    ..author = json['Author'] as String
    ..img = json['Img'] as String
    ..desc = json['Desc'] as String
    ..bookStatus = json['BookStatus'] as String
    ..lastChapterId = json['LastChapterId'] as String
    ..lastChapter = json['LastChapter'] as String
    ..cName = json['CName'] as String
    ..updateTime = json['UpdateTime'] as String
    ..isExist = json['isExist'] as int
    ..storeLastChapterId = json['storeLastChapterId'] as String
    ..currentChapterId = json['currentChapterId'] as String
    ..currentPageIndex = json['currentPageIndex'] as int;
}

Map<String, dynamic> _$NovelToJson(Novel instance) => <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Author': instance.author,
      'Img': instance.img,
      'Desc': instance.desc,
      'BookStatus': instance.bookStatus,
      'LastChapterId': instance.lastChapterId,
      'LastChapter': instance.lastChapter,
      'CName': instance.cName,
      'UpdateTime': instance.updateTime,
      'isExist': instance.isExist,
      'storeLastChapterId': instance.storeLastChapterId,
      'currentChapterId': instance.currentChapterId,
      'currentPageIndex': instance.currentPageIndex,
    };
