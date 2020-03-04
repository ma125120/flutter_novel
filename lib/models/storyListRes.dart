import 'package:json_annotation/json_annotation.dart';
import "npc.dart";
import "plotItem.dart";
part 'storyListRes.g.dart';

@JsonSerializable()
class StoryListRes {
    StoryListRes();

    List<Npc> npcInfos;
    List<PlotItem> plotItems;
    
    factory StoryListRes.fromJson(Map<String,dynamic> json) => _$StoryListResFromJson(json);
    Map<String, dynamic> toJson() => _$StoryListResToJson(this);
}
