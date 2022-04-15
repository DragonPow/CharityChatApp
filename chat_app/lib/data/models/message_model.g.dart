// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      id: json['id'] as String,
      senderId: json['creatorId'] as String,
      roomId: json['roomId'] as String,
      createTime: DateTime.parse(json['timeCreate'] as String),
      content: json['content'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creatorId': instance.senderId,
      'roomId': instance.roomId,
      'timeCreate': instance.createTime.toIso8601String(),
      'content': instance.content,
      'type': _$MessageTypeEnumMap[instance.type],
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.video: 'video',
  MessageType.file: 'file',
};
