part of 'chat_detail_bloc.dart';

abstract class ChatDetailEvent extends Equatable {
  const ChatDetailEvent();

  @override
  List<Object> get props => [];
}

class ChatDetailLoadMessage extends ChatDetailEvent{
  final String roomId;
  final int startIndex;
  final int number;
  const ChatDetailLoadMessage({Key? key, required this.number, required this.roomId, required this.startIndex});
}

class ChatDetailSendTextMessage extends ChatDetailEvent{
    final String content;
    final String roomId;
    const ChatDetailSendTextMessage({Key?key, required this.content, required this.roomId});
}
class ChatDetailSendFileMessage extends ChatDetailEvent{
}