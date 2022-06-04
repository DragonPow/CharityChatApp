// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      roomId: json['roomId'] as String,
      createTime: DateTime.parse(json['createTime'] as String),
      content: json['content'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'roomId': instance.roomId,
      'createTime': instance.createTime.toIso8601String(),
      'content': instance.content,
      'type': _$MessageTypeEnumMap[instance.type],
    };

const _$MessageTypeEnumMap = {
  MessageChatType.text: 'text',
  MessageChatType.image: 'image',
  MessageChatType.video: 'video',
  MessageChatType.file: 'file',
};
