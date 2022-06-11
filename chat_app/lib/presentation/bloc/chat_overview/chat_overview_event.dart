part of 'chat_overview_bloc.dart';

abstract class ChatOverviewEvent extends Equatable {
  const ChatOverviewEvent();

  @override
  List<Object> get props => [];
}

class ChatOverviewLoad extends ChatOverviewEvent {
  final int startIndex;
  final int number;
  final String searchtype;

  const ChatOverviewLoad({
    Key? key,
    required this.number,
    required this.searchtype,
    required this.startIndex,
  });

  @override
  List<Object> get props => [startIndex, number, searchtype];
}

class ChatOverviewLoadInit extends ChatOverviewEvent {
  final int number;
  final String searchtype;
  final int startIndex;

  const ChatOverviewLoadInit({
    Key? key,
    required this.number,
    required this.searchtype,
    this.startIndex = 0,
  });

  @override
  List<Object> get props => [startIndex, number, searchtype];
}

class ChatOverviewUpdate extends ChatOverviewEvent {
  final List<RoomOverviewEntity> rooms;
  const ChatOverviewUpdate({
    Key? key,
    required this.rooms,
  });
}