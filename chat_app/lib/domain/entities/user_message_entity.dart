import 'package:chat_app/domain/entities/base_user_entity.dart';

class UserMessageEntity extends BaseUserEntity {
  final String avatarUri;

  UserMessageEntity({
    required String id,
    required String name,
    required this.avatarUri,
  }) : super(
          id: id,
          name: name,
        );
}
