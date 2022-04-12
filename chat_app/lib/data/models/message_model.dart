import 'package:chat_app/helper/enum.dart';
import 'package:json_annotation/json_annotation.dart';


part 'message_model.g.dart';

@JsonSerializable()

class MessageModel {
  final String id;
  final String creatorId;
  final String roomId;
  final DateTime timeCreate;
  final String content;
  final MessageType type;

  MessageModel({
    required this.id,
    required this.creatorId,
    required this.roomId,
    required this.timeCreate,
    required this.content,
    required this.type,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}
