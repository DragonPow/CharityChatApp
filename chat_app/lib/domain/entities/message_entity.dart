import 'package:chat_app/domain/entities/user_message_entity.dart';
import 'package:chat_app/helper/enum.dart';

class MessageEntity implements Comparable<MessageEntity> {
  final String id;
  final String content;
  final MessageChatType type;
  final UserMessageEntity creator;
  final DateTime timeCreate;

  MessageEntity({
    required this.id,
    required this.content,
    required this.type,
    required this.creator,
    required this.timeCreate,
  });

  factory MessageEntity.sending({required String content, required MessageChatType type, required UserMessageEntity creator}) {
    return MessageEntity(id: '', content: content, type: type, creator: creator, timeCreate: DateTime.now());
  }

  factory MessageEntity.fromJson(Map<String, dynamic> json) => MessageEntity(
      id: json['id'] as String,
      timeCreate: DateTime.parse(json['createTime'] as String),
      content: json['content'] as String,
      creator: UserMessageEntity.fromJson(json['sender']),
      type: MessageChatType.text //json['typeContent'] ?? ; //as MessageChatType,
    );
  

  

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MessageEntity &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int compareTo(MessageEntity other) {
    //Compare time before, after compare id
    int rs = timeCreate.compareTo(other.timeCreate);
    return rs != 0 ? rs : id.compareTo(other.id);
  }
}
