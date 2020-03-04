// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storyListRes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryListRes _$StoryListResFromJson(Map<String, dynamic> json) {
  return StoryListRes()
    ..npcInfos = (json['npcInfos'] as List)
        ?.map((e) => e == null ? null : Npc.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..plotItems = (json['plotItems'] as List)
        ?.map((e) =>
            e == null ? null : PlotItem.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$StoryListResToJson(StoryListRes instance) =>
    <String, dynamic>{
      'npcInfos': instance.npcInfos,
      'plotItems': instance.plotItems,
    };
