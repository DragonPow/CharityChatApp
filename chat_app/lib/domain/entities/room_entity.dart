import 'package:chat_app/domain/entities/message_entity.dart';

import 'base_user_entity.dart';

class RoomEntity {
  final String id;
  final String name;
  final List<BaseUserEntity> users;
  final List<MessageEntity> messages;

  RoomEntity({
    required this.id,
    required this.name,
    required this.users,
    required this.messages,
  });
}
