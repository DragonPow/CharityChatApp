// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUri: json['imageUri'] as String,
      birthday: DateTime.parse(json['birthday'] as String),
      gender: json['gender'] as int,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUri': instance.imageUri,
      'birthday': instance.birthday.toIso8601String(),
      'gender': instance.gender,
    };
