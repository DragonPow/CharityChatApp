import 'package:chat_app/data/models/message_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'room_model.g.dart';

@JsonSerializable()
class RoomModel {
  final String id;
  final List<String> joiners;
  final MessageModel lastMessages;

  RoomModel({
    required this.id,
    required this.joiners,
    required this.lastMessages,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => _$RoomModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoomModelToJson(this);
}
