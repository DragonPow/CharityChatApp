part of 'chat_overview_bloc.dart';

abstract class ChatOverviewState extends Equatable {
  const ChatOverviewState();
  
  @override
  List<Object> get props => [];
}

class ChatOverviewInitial extends ChatOverviewState {}
class ChatOverviewLoading extends ChatOverviewState {}
class ChatOverviewLoadFail extends ChatOverviewState {}
class ChatOverviewLoadSuccess extends ChatOverviewState {
  final List<RoomOverviewEntity> listRoomOverview;
  const ChatOverviewLoadSuccess({Key? key, required this.listRoomOverview});
}

