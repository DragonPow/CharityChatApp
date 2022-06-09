part of 'message_setting_bloc.dart';

class MessageSettingState extends Equatable {
  const MessageSettingState();

  @override
  List<Object?> get props => [];
}

class MessageSettingImageState extends MessageSettingState {
  final List imagesUri;
  final bool isLoading;
  final bool isFull;
  final Object? error;

  const MessageSettingImageState({
    required this.imagesUri,
    required this.isFull,
    required this.isLoading,
    required this.error,
  });

  @override
  List<Object?> get props => [imagesUri, isLoading, isFull, error];
}

class MessageSettingFindMessageState extends MessageSettingState {
  final List<MessageEntity> messages;
  final bool isLoading;
  final bool isFull;
  final Object? error;

  const MessageSettingFindMessageState({
    required this.messages,
    required this.isFull,
    required this.isLoading,
    required this.error,
  });

  @override
  List<Object?> get props => [messages, isLoading, isFull, error];
}

class MessageSettingNameAliasState extends MessageSettingState {
  final Map<UserMessageEntity, String> nameAliases;
  final Object? error;

  const MessageSettingNameAliasState({
    required this.nameAliases,
    required this.error,
  });

  @override
  List<Object?> get props => [nameAliases, error];
}

class MessageSettingJoinerState extends MessageSettingNameAliasState {
  final List<String> addJoiners;
  final List<String> deleteJoiners;

  const MessageSettingJoinerState({
    required this.addJoiners,
    required this.deleteJoiners,
    required Map<UserMessageEntity, String> nameAliases,
    required Object? error,
  }) : super(
          nameAliases: nameAliases,
          error: error,
        );

  @override
  List<Object?> get props => [addJoiners, deleteJoiners, nameAliases, error];
}
