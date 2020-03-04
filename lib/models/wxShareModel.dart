import 'package:json_annotation/json_annotation.dart';

part 'wxShareModel.g.dart';

@JsonSerializable()
class WxShareModel {
    WxShareModel();

    String type;
    String hdImageData;
    String userName;
    String path;
    num miniProgramType;
    String title;
    String webpageUrl;
    String shareData;
    
    factory WxShareModel.fromJson(Map<String,dynamic> json) => _$WxShareModelFromJson(json);
    Map<String, dynamic> toJson() => _$WxShareModelToJson(this);
}
