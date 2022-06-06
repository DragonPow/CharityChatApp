part of 'chat_detail_bloc.dart';

abstract class ChatDetailState extends Equatable {
  const ChatDetailState();

  @override
  List<Object> get props => [];
}

class ChatDetailInitial extends ChatDetailState {}

class ChatDetailLoading extends ChatDetailState {}

class ChatDetailLoadFail extends ChatDetailState {}

class ChatDetailLoadSuccess extends ChatDetailState {
  final List<MessageEntity> listMessage;
  const ChatDetailLoadSuccess({Key? key, required this.listMessage});
}
class ChatDetailTypingMessage extends ChatDetailState {}
class ChatDetailSendMessageFaild extends ChatDetailState {}
class ChatDetailSendMessageSuccess extends ChatDetailState {}
