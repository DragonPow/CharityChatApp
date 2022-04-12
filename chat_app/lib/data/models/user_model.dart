import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String imageUri;
  final DateTime birthday;
  final int gender;
  
  UserModel({
    required this.id,
    required this.name,
    required this.imageUri,
    required this.birthday,
    required this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
