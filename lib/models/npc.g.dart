// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'npc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Npc _$NpcFromJson(Map<String, dynamic> json) {
  return Npc()
    ..id = json['id'] as String
    ..image = json['image'] as String
    ..name = json['name'] as String
    ..signature = json['signature'] as String
    ..alias = json['alias'] as String;
}

Map<String, dynamic> _$NpcToJson(Npc instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'name': instance.name,
      'signature': instance.signature,
      'alias': instance.alias,
    };
