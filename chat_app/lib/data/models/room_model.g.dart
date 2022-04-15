// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => RoomModel(
      id: json['id'] as String,
      joiners:
          (json['joiners'] as List<dynamic>).map((e) => e as String).toList(),
      lastMessages:
          MessageModel.fromJson(json['lastMessages'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RoomModelToJson(RoomModel instance) => <String, dynamic>{
      'id': instance.id,
      'joiners': instance.joiners,
      'lastMessages': instance.lastMessages,
    };
