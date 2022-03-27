import 'package:chat_app/domain/entities/user_message_entity.dart';
import 'package:chat_app/helper/enum.dart';

class MessageEntity {
  final String id;
  final String content;
  final MessageType type;
  final UserMessageEntity creator;
  final DateTime timeCrete;

  MessageEntity({
    required this.id,
    required this.content,
    required this.type,
    required this.creator,
    required this.timeCrete,
  });
}
