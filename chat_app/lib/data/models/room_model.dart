import 'package:chat_app/data/models/message_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'room_model.g.dart';

@JsonSerializable()
class RoomModel {
  final String id;
  final String name;
  final List<String> joinersId;
  final MessageModel lastMessages;
  final String avatarId;

  RoomModel({
    required this.id,
    required this.name,
    required this.joinersId,
    required this.lastMessages,
    required this.avatarId,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => _$RoomModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoomModelToJson(this);
}
