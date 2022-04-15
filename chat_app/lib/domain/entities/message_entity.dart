import 'package:chat_app/domain/entities/user_message_entity.dart';
import 'package:chat_app/helper/enum.dart';

class MessageEntity implements Comparable<MessageEntity> {
  final String id;
  final String content;
  final MessageType type;
  final UserMessageEntity creator;
  final DateTime timeCreate;

  MessageEntity({
    required this.id,
    required this.content,
    required this.type,
    required this.creator,
    required this.timeCreate,
  });

  factory MessageEntity.sending({required String content, required MessageType type, required UserMessageEntity creator}) {
    return MessageEntity(id: '', content: content, type: type, creator: creator, timeCreate: DateTime.now());
  }

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
