part of 'chat_bloc.dart';

@immutable
class ChatLoaded extends Equatable {
  final List<MessageEntity> messages;
  final List<MessageEntity> messagesSending;
  final List<MessageEntity> messagesError;

  const ChatLoaded({
    required this.messages,
    this.messagesSending = const [],
    this.messagesError = const [],
  });

  ChatLoaded.clone(ChatLoaded object)
      : this(
          messages: object.messages,
          messagesSending: object.messagesSending,
          messagesError: object.messagesError,
        );

  ChatLoaded copyWith({
    List<MessageEntity>? messages,
    List<MessageEntity>? messagesSending,
    List<MessageEntity>? messagesError,
  }) =>
      ChatLoaded(
        messages: messages ?? this.messages,
        messagesError: messagesError ?? this.messagesError,
        messagesSending: messagesSending ?? this.messagesSending,
      );

  @override
  List<Object> get props => [messages, messagesSending, messagesError];
}

class ChatLoadInProcess extends ChatLoaded {
  const ChatLoadInProcess({
    required List<MessageEntity> messages,
    messagesSending = const [],
    messagesError = const [],
  }) : super(messages: messages, messagesSending: messagesSending);

    ChatLoadInProcess.clone(ChatLoaded object)
      : this(
          messages: object.messages,
          messagesSending: object.messagesSending,
          messagesError: object.messagesError,
        );
}

class ChatLoadFail extends ChatLoaded {
  final dynamic error;
  ChatLoadFail({
    required List<MessageEntity> messages,
    required this.error,
    messagesSending = const [],
    messagesError = const [],
  }) : super(messages: messages, messagesSending: messagesSending);

  ChatLoadFail.clone(ChatLoaded object)
      : this(
          messages: object.messages,
          error: object is ChatLoadFail ? object.error : null,
          messagesSending: object.messagesSending,
          messagesError: object.messagesError,
        );

  @override
  ChatLoadFail copyWith({
    List<MessageEntity>? messages,
    dynamic error,
    List<MessageEntity>? messagesSending,
    List<MessageEntity>? messagesError,
  }) =>
      ChatLoadFail(
        messages: messages ?? this.messages,
        error: error ?? this.error,
        messagesError: messagesError ?? this.messagesError,
        messagesSending: messagesSending ?? this.messagesSending,
      );
}
