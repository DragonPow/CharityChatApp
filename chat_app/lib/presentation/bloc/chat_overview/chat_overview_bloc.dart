import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:chat_app/domain/entities/room_overview_entity.dart';
import 'package:chat_app/domain/repositories/room_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:chat_app/utils/account.dart';
import 'package:stream_transform/stream_transform.dart';

part 'chat_overview_event.dart';
part 'chat_overview_state.dart';

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ChatOverviewBloc extends Bloc<ChatOverviewEvent, ChatOverviewState> {
  static const throttleDuration = Duration(seconds: 1);
  final IRoomRepository _roomRepository;
  late StreamController<List<RoomOverviewEntity>> _streamRoom;

  ChatOverviewBloc(this._roomRepository) : super(ChatOverviewState.initial()) {
    on<ChatOverviewLoad>(
      _mapChatOverViewLoadEventToState,
      transformer: throttleDroppable(throttleDuration),
    );
    on<ChatOverviewUpdate>(
      _mapChatOverviewUpdateEventToState,
      transformer: concurrent(),
    );
    on<ChatOverviewLoadInit>(
      _mapChatOverviewLoadInitToState,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  _combineListRoom(
      List<RoomOverviewEntity> source, List<RoomOverviewEntity> dest) {
    final newSource = [...source]..retainWhere((s) => !dest.any((d) => s.id == d.id));
    return [...newSource, ...dest];
  }

  FutureOr<void> _mapChatOverViewLoadEventToState(
      ChatOverviewLoad event, Emitter<ChatOverviewState> emit) async {
    emit(ChatOverviewState(
      listRoom: state.listSortedRoom,
      isLoading: true,
      error: null,
      isFull: state.isFull,
    ));

    if (Account.instance == null) {
      log('Cannot load room, account must be not null');
      return;
    }

    try {
      List<RoomOverviewEntity> newRooms =
          await _roomRepository.getRoomOverviews(
        Account.instance!.id,
        event.startIndex,
        event.number,
        event.searchtype,
      );
      emit(ChatOverviewState(
        listRoom: _combineListRoom(state.listSortedRoom, newRooms),
        isLoading: false,
        error: null,
        isFull: newRooms.length < event.number,
      ));
    } catch (error) {
      print("Error load OverviewChat");
      print(error);
      emit(ChatOverviewState(
        listRoom: state.listSortedRoom,
        isLoading: false,
        error: error,
        isFull: state.isFull,
      ));
    }
  }

  FutureOr<void> _mapChatOverviewLoadInitToState(
      ChatOverviewLoadInit event, Emitter<ChatOverviewState> emit) {
    add(ChatOverviewLoad(
      number: 10,
      searchtype: event.searchtype,
      startIndex: 0,
    ));
    _streamRoom = _roomRepository.getStreamRoom();
    _streamRoom.stream.listen((rooms) {
      add(ChatOverviewUpdate(rooms: rooms..retainWhere((room) => room.type == event.searchtype)));
    });
  }

  FutureOr<void> _mapChatOverviewUpdateEventToState(
      ChatOverviewUpdate event, Emitter<ChatOverviewState> emit) {
    print('Room is updated');
    emit(ChatOverviewState(
      listRoom: _combineListRoom(state.listSortedRoom, event.rooms),
      isLoading: state.isLoading,
      error: state.error,
      isFull: state.isFull,
    ));
  }
}
