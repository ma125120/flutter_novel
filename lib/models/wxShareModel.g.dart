// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wxShareModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WxShareModel _$WxShareModelFromJson(Map<String, dynamic> json) {
  return WxShareModel()
    ..type = json['type'] as String
    ..hdImageData = json['hdImageData'] as String
    ..userName = json['userName'] as String
    ..path = json['path'] as String
    ..miniProgramType = json['miniProgramType'] as num
    ..title = json['title'] as String
    ..webpageUrl = json['webpageUrl'] as String
    ..shareData = json['shareData'] as String;
}

Map<String, dynamic> _$WxShareModelToJson(WxShareModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'hdImageData': instance.hdImageData,
      'userName': instance.userName,
      'path': instance.path,
      'miniProgramType': instance.miniProgramType,
      'title': instance.title,
      'webpageUrl': instance.webpageUrl,
      'shareData': instance.shareData,
    };
