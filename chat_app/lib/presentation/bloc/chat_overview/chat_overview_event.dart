part of 'chat_overview_bloc.dart';

abstract class ChatOverviewEvent extends Equatable {
  const ChatOverviewEvent();

  @override
  List<Object> get props => [];
}

class ChatOverviewLoad extends ChatOverviewEvent  {
  final String userId;
  final int startIndex;
  final int number;
  final String searchtype;
  const ChatOverviewLoad({Key? key, required this.number, required this.searchtype, required this.startIndex, required this.userId});
}
