part of 'message_setting_bloc.dart';

class MessageSettingState extends Equatable {
  const MessageSettingState();

  @override
  List<Object?> get props => [];
}

class MessageSettingImageFileState extends MessageSettingState {
  final List imagesUri;
  final List files;
  final bool isLoading;
  final bool isImageFull;
  final bool isFileFull;
  final Object? error;

  const MessageSettingImageFileState({
    required this.imagesUri,
    required this.files,
    required this.isImageFull,
    required this.isFileFull,
    required this.isLoading,
    required this.error,
  });

  const MessageSettingImageFileState.initial({
    this.imagesUri = const [],
    this.files = const [],
    this.isImageFull = false,
    this.isFileFull = false,
    this.isLoading = false,
    this.error,
  });

  MessageSettingImageFileState copyWith({
    List? imagesUri,
    List? files,
    bool? isLoading,
    bool? isImageFull,
    bool? isFileFull,
    Object? error,
  }) {
    return MessageSettingImageFileState(
      imagesUri: imagesUri ?? this.imagesUri,
      files: files ?? this.files,
      isImageFull: isImageFull ?? this.isImageFull,
      isFileFull: isFileFull ?? this.isFileFull,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props =>
      [imagesUri, files, isLoading, isImageFull, isFileFull, error];
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
