import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/entities/room_entity.dart';
import 'package:chat_app/domain/repositories/room_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomsState> {
  final IRoomRepository roomRepository;
  RoomBloc({required this.roomRepository})
      : super(const RoomsLoadSuccess(rooms: [])) {
    on<LoadRoom>(onLoadRoom);
    on<FindRoomByName>(onFindRoomByName);
  }

  FutureOr<void> onFindRoomByName(event, emit) async {
    try {
      emit(RoomsLoadInProcess(rooms: state.rooms));

      final rooms = await roomRepository.findRoomsByName(event.textMatch);
      rooms.addAll(state.rooms..removeWhere((room) => rooms.contains(room)));

      emit(RoomsLoadSuccess(rooms: rooms));
    } catch (e) {
      emit(RoomsLoadFail(rooms: state.rooms, error: e.toString()));
    }
  }

  FutureOr<void> onLoadRoom(event, emit) async {
    try {
      emit(RoomsLoadInProcess(rooms: state.rooms));

      final newRooms =
          await roomRepository.getRooms(event.startIndex, event.number);

      newRooms
          .addAll(state.rooms..removeWhere((room) => newRooms.contains(room)));

      emit(RoomsLoadSuccess(rooms: newRooms));
    } catch (e) {
      emit(RoomsLoadFail(rooms: state.rooms, error: e.toString()));
    }
  }
}
