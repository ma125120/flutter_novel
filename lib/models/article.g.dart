// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) {
  return Article()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..volumeName = json['volumeName'] as String
    ..prevId = json['prevId'] as String
    ..nextId = json['nextId'] as String
    ..content = json['content'] as String;
}

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'volumeName': instance.volumeName,
      'prevId': instance.prevId,
      'nextId': instance.nextId,
      'content': instance.content,
    };
