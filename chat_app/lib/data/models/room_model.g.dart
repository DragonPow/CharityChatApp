// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => RoomModel(
      id: json['id'] as String,
      name: json['name'] as String,
      joinersId:
          (json['joinersId'] as List<dynamic>).map((e) => e as String).toList(),
      lastMessages:
          MessageModel.fromJson(json['lastMessages'] as Map<String, dynamic>),
      avatarId: json['avatarId'] as String,
    );

Map<String, dynamic> _$RoomModelToJson(RoomModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'joinersId': instance.joinersId,
      'lastMessages': instance.lastMessages,
      'avatarId': instance.avatarId,
    };
