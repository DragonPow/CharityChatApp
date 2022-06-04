import 'package:chat_app/domain/entities/base_user_entity.dart';

class UserMessageEntity extends BaseUserEntity {
  final String? avatarUri;

  UserMessageEntity({
    required String id,
    required String name,
    required this.avatarUri,
  }) : super(id: id, name: name);

  factory UserMessageEntity.fromJson(Map<String, dynamic> json) =>
      UserMessageEntity(
          id: json["id"], name: json["name"], avatarUri: json["imageUri"]);
}
