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
      type: $enumDecode(_$MessageChatTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'roomId': instance.roomId,
      'createTime': instance.createTime.toIso8601String(),
      'content': instance.content,
      'type': _$MessageChatTypeEnumMap[instance.type],
    };

const _$MessageChatTypeEnumMap = {
  MessageChatType.text: 'text',
  MessageChatType.image: 'image',
  MessageChatType.file: 'file',
  MessageChatType.system: 'system',
};
