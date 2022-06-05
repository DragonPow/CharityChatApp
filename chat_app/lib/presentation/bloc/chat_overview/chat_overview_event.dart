part of 'chat_overview_bloc.dart';

abstract class ChatOverviewEvent extends Equatable {
  const ChatOverviewEvent();

  @override
  List<Object> get props => [];
}

class ChatOverviewLoad extends ChatOverviewEvent  {}
