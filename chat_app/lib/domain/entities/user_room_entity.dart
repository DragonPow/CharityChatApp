import 'package:chat_app/domain/entities/base_user_entity.dart';

class UserRoomEntity extends BaseUserEntity {
  final String? avatarUri;
  final String? nameAlias;

  UserRoomEntity({
    required String id,
    required String name,
    required this.avatarUri,
    required this.nameAlias,
  }) : super(id: id, name: name);

  factory UserRoomEntity.fromJson(Map<String, dynamic> json) => UserRoomEntity(
      id: json["id"],
      name: json["name"],
      avatarUri: json["imageUri"],
      nameAlias: json['nameAlias']);

  UserRoomEntity copyWith({
    String? id,
    String? name,
    String? avatarUri,
    String? nameAlias,
  }) =>
      UserRoomEntity(
          id: id ?? this.id,
          name: name ?? this.name,
          avatarUri: avatarUri ?? this.avatarUri,
          nameAlias: nameAlias ?? this.nameAlias);
}
