part of 'chat_detail_bloc.dart';

abstract class ChatDetailEvent extends Equatable {
  const ChatDetailEvent();
}

class ChatDetailLoad extends ChatDetailEvent {
  const ChatDetailLoad({
    required this.number,
    required this.roomId,
    required this.startIndex,
  });

  final String roomId;
  final int startIndex;
  final int number;

  @override
  List<Object> get props => [roomId, startIndex, number];
}

class ChatDetailSend extends ChatDetailEvent {
  const ChatDetailSend({
    Key? key,
    required this.content,
    required this.roomId,
    required this.file,
  });

  final String? content;
  final String roomId;
  final File? file;

  @override
  List<Object?> get props => [roomId, content, file];
}
