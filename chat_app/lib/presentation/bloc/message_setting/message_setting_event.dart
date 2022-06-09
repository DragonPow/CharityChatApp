part of 'message_setting_bloc.dart';

abstract class MessageSettingEvent extends Equatable {
  const MessageSettingEvent();

  @override
  List<Object?> get props => [];
}

class MessageSettingLoadImageFile extends MessageSettingEvent {
  final int startIndex;
  final int number;
  final String roomId;
  final String typeLoad;

  const MessageSettingLoadImageFile(
      {required this.startIndex, required this.number, required this.roomId, required this.typeLoad});

  @override
  List<Object?> get props => [startIndex, number, roomId, typeLoad];
}

class MessageSettingFindMessage extends MessageSettingEvent {
  final int startIndex;
  final int number;
  final String roomId;
  final String textMatch;

  const MessageSettingFindMessage({
    required this.startIndex,
    required this.number,
    required this.roomId,
    required this.textMatch,
  });

  @override
  List<Object?> get props => [startIndex, number, roomId, textMatch];
}

class MessageSettingFindNameAlias extends MessageSettingEvent {
  final String roomId;

  const MessageSettingFindNameAlias({
    required this.roomId,
  });

  @override
  List<Object?> get props => [roomId];
}

class MessageSettingChangeNameAlias extends MessageSettingEvent {
  final String roomId;
  final Map<String, String> newNameAlias;

  const MessageSettingChangeNameAlias({
    required this.newNameAlias,
    required this.roomId,
  });

  @override
  List<Object?> get props => [roomId, newNameAlias];
}

class MessageSettingUpdateJoiners extends MessageSettingEvent {
  final String roomId;
  final List<String> deletedJoiners;
  final List<String> addedJoiners;

  const MessageSettingUpdateJoiners({
    required this.deletedJoiners,
    required this.addedJoiners,
    required this.roomId,
  });

  @override
  List<Object?> get props => [roomId, addedJoiners, deletedJoiners];
}