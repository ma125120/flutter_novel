// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plotItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlotItem _$PlotItemFromJson(Map<String, dynamic> json) {
  return PlotItem()
    ..id = json['id'] as String
    ..entranceCover = json['entranceCover'] as String
    ..title = json['title'] as String
    ..subTitle = json['subTitle'] as String
    ..episodes = json['episodes'] as num
    ..synopsis = json['synopsis'] as String
    ..relevanceNpcs =
        (json['relevanceNpcs'] as List)?.map((e) => e as String)?.toList()
    ..wxShareModel = json['wxShareModel'] == null
        ? null
        : WxShareModel.fromJson(json['wxShareModel'] as Map<String, dynamic>)
    ..plotSeason = json['plotSeason'] as Map<String, dynamic>;
}

Map<String, dynamic> _$PlotItemToJson(PlotItem instance) => <String, dynamic>{
      'id': instance.id,
      'entranceCover': instance.entranceCover,
      'title': instance.title,
      'subTitle': instance.subTitle,
      'episodes': instance.episodes,
      'synopsis': instance.synopsis,
      'relevanceNpcs': instance.relevanceNpcs,
      'wxShareModel': instance.wxShareModel,
      'plotSeason': instance.plotSeason,
    };
