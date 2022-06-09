import 'dart:convert';
import 'dart:io';

import 'package:chat_app/domain/entities/user_message_entity.dart';
import 'package:chat_app/helper/enum.dart';
import 'package:chat_app/helper/helper.dart';
import 'package:uuid/uuid.dart';

enum MessageState {
  normal,
  sending,
  error,
}

class MessageEntity implements Comparable<MessageEntity> {
  final String id;
  final dynamic value;
  final MessageChatType type;
  final UserMessageEntity creator;
  final DateTime timeCreate;
  final MessageState state;

  String get getName => type == MessageChatType.text
      ? value as String
      : value is File
          ? getNameOfFile(value as File)
          : value['name'] ?? 'No name';
  String get getUri =>
      value is File ? (value as File).uri.path : parseToServerUri(value['uri']);

  MessageEntity({
    required this.id,
    required this.value,
    required this.type,
    required this.creator,
    required this.timeCreate,
    this.state = MessageState.normal,
  });

  static GetTypeMessage(dynamic value) {}

  factory MessageEntity.send({
    required dynamic value,
    required MessageChatType type,
    required UserMessageEntity creator,
    MessageState state = MessageState.sending,
  }) {
    return MessageEntity(
      id: Uuid().v4(),
      value: value,
      type: type,
      creator: creator,
      timeCreate: DateTime.now(),
      state: state,
    );
  }

  factory MessageEntity.fromJson(Map<String, dynamic> json) => MessageEntity(
      id: json['id'] as String,
      timeCreate: DateTime.parse(json['createTime'] as String),
      value: (json['typeContent'] == 'text')
          ? json['content'] as String
          : {
              'uri': json['content'] as String,
              'name': jsonDecode(json['args'])['nameFile'] as String,
              'size': jsonDecode(json['args'])['size'] as int,
            },
      creator: UserMessageEntity.fromJson(json['sender']),
      type: convertToMessageChatType(
          json['typeContent']) //json['typeContent'] ?? ; //as MessageChatType,
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

  MessageEntity copyWith({
    String? id,
    dynamic? value,
    MessageChatType? type,
    UserMessageEntity? creator,
    DateTime? timeCreate,
    MessageState? state,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      value: value ?? this.value,
      type: type ?? this.type,
      creator: creator ?? this.creator,
      timeCreate: timeCreate ?? this.timeCreate,
      state: state ?? this.state,
    );
  }
}
