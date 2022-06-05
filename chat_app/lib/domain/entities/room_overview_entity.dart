import 'package:chat_app/domain/entities/message_entity.dart';

class RoomOverviewEntity implements Comparable<RoomOverviewEntity>{
  final String id;
  final String name;
  final String avatarUrl;
  final MessageEntity lastMessage;

  RoomOverviewEntity({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.avatarUrl
  });

  factory RoomOverviewEntity.fromJson(Map<String, dynamic> json) => RoomOverviewEntity(
    id: json["id"] as String, 
    name: json["name"] as String, 
    lastMessage: MessageEntity.fromJson(json["lastMessage"]), 
    avatarUrl: json["avatarId"]);
    
  @override
  bool operator == (Object other) {
    return
       identical(this, other) ||
       other is RoomOverviewEntity &&
       runtimeType == other.runtimeType &&
       id == other.id;
  }

  @override
  int compareTo(RoomOverviewEntity other) {
    if (lastMessage != null ) return lastMessage.compareTo(other.lastMessage);
    return id.compareTo(other.id);
  }
}
