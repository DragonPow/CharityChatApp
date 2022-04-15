part of 'room_bloc.dart';

@immutable
abstract class RoomsState extends Equatable {
  final List<RoomEntity> rooms;

  const RoomsState({required this.rooms});

  @override
  List<Object> get props => [rooms];
}

class RoomsLoadSuccess extends RoomsState {
  const RoomsLoadSuccess({required List<RoomEntity> rooms})
      : super(rooms: rooms);
}

class RoomsLoadFail extends RoomsState {
  final String error;
  const RoomsLoadFail({required List<RoomEntity> rooms, required this.error})
      : super(rooms: rooms);
}

class RoomsLoadInProcess extends RoomsState {
  const RoomsLoadInProcess({required List<RoomEntity> rooms})
      : super(rooms: rooms);
}

