import 'package:chat_app/domain/entities/message_entity.dart';

class RoomOverviewEntity implements Comparable<RoomOverviewEntity>{
  final String id;
  final String name;
  final String? avatarUrl;
  final MessageEntity? lastMessage;
  final String type;

  RoomOverviewEntity({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.avatarUrl,
    required this.type,
  });

  factory RoomOverviewEntity.fromJson(Map<String, dynamic> json) => RoomOverviewEntity(
    id: json["id"] as String, 
    name: json["name"] as String, 
    lastMessage: json["lastMessage"] != null? MessageEntity.fromJson(json["lastMessage"]) : null, 
    avatarUrl: json["avatarId"],
    type: json['typeRoom']);
    
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
    if (lastMessage != null ) return lastMessage!.compareTo(other.lastMessage!);
    return id.compareTo(other.id);
  }
}
