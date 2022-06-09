part of 'new_message_bloc.dart';

abstract class NewMessageEvent extends Equatable {
  const NewMessageEvent();

  @override
  List<Object> get props => [];
}

class NewMessageLoad extends NewMessageEvent{
  final int startIndex;
  final int number;
  const NewMessageLoad({Key? key, required this.number, required this.startIndex});
}

class NewMessageOpenRoom extends NewMessageEvent{
  final BaseUserEntity otherUser;
  const NewMessageOpenRoom({Key? key, required this.otherUser});
}
