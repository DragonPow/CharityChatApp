part of 'room_bloc.dart';

@immutable
abstract class RoomEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadRoom extends RoomEvent {
  final int startIndex;
  final int number;

  LoadRoom({required this.startIndex, required this.number});

  @override
  List<Object> get props => [startIndex, number];
}

class FindRoomByName extends RoomEvent {
  final String textMatch;
  final int startIndex;
  final int number;

  FindRoomByName(
      {required this.textMatch,
      required this.startIndex,
      required this.number});

  @override
  List<Object> get props => [textMatch, startIndex, number];
}
