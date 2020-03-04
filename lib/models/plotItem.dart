import 'package:json_annotation/json_annotation.dart';
import "wxShareModel.dart";
part 'plotItem.g.dart';

@JsonSerializable()
class PlotItem {
    PlotItem();

    String id;
    String entranceCover;
    String title;
    String subTitle;
    num episodes;
    String synopsis;
    List<String> relevanceNpcs;
    WxShareModel wxShareModel;
    Map<String,dynamic> plotSeason;
    
    factory PlotItem.fromJson(Map<String,dynamic> json) => _$PlotItemFromJson(json);
    Map<String, dynamic> toJson() => _$PlotItemToJson(this);
}
