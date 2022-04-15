import 'package:chat_app/domain/entities/base_user_entity.dart';

class UserActiveEntity extends BaseUserEntity {
  final String avatarUri;

  UserActiveEntity({
    required String id,
    required String name,
    required this.avatarUri,
  }) : super(
          id: id,
          name: name,
        );
}
