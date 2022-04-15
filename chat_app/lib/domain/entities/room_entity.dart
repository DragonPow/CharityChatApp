import 'package:chat_app/domain/entities/message_entity.dart';

import 'base_user_entity.dart';

class RoomEntity implements Comparable<RoomEntity>{
  final String id;
  final String name;
  final List<BaseUserEntity> users;
  final List<MessageEntity> messages;

  MessageEntity? get lastMessage => messages.isNotEmpty ? messages.last : null;

  RoomEntity({
    required this.id,
    required this.name,
    required this.users,
    required this.messages,
  });

  @override
  bool operator == (Object other) {
    return
       identical(this, other) ||
       other is RoomEntity &&
       runtimeType == other.runtimeType &&
       id == other.id;
  }

  @override
  int compareTo(RoomEntity other) {
    if (lastMessage != null && lastMessage != null) return lastMessage!.compareTo(other.lastMessage!);
    return id.compareTo(other.id);
  }
}
