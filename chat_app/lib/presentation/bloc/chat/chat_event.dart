part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendMessage extends ChatEvent {
  final String content;
  final MessageType type;
  SendMessage({required this.content, required this.type});

  @override
  List<Object> get props => [];
}

class LoadChat extends ChatEvent {
  final String roomId;
  final int startIndex;
  final int number;

  LoadChat(
      {required this.roomId, required this.startIndex, required this.number});

  @override
  List<Object> get props => [roomId, startIndex, number];
}

class FindChatByContent extends LoadChat {
  final String textMatch;

  FindChatByContent({
    required String roomId,
    required this.textMatch,
    required int startIndex,
    required int number,
  }) : super(roomId: roomId, startIndex: startIndex, number: number);

  @override
  List<Object> get props => [roomId, textMatch, startIndex, number];
}

class LoadImagesChat extends LoadChat {
  LoadImagesChat({
    required String roomId,
    required int startIndex,
    required int number,
  }) : super(roomId: roomId, startIndex: startIndex, number: number);
}

class LoadFilesChat extends LoadChat {
  LoadFilesChat({
    required String roomId,
    required int startIndex,
    required int number,
  }) : super(roomId: roomId, startIndex: startIndex, number: number);
}
