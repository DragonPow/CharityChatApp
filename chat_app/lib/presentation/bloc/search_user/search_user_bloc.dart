import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/entities/base_user_entity.dart';
import 'package:chat_app/domain/entities/room_entity.dart';
import 'package:chat_app/domain/entities/room_overview_entity.dart';
import 'package:chat_app/domain/entities/user_active_entity.dart';
import 'package:chat_app/domain/repositories/room_repository.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_user_event.dart';
part 'search_user_state.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  final IUserRepository _iUserRepository;
  final IRoomRepository _iRoomRepository;
  SearchUserBloc(this._iUserRepository, this._iRoomRepository)
      : super(SearchUserInitial()) {
    on<SearchUserLoad>(_mapSearchUserLoadToState);
    on<SearchUserSearch>(
      _mapSearchUserSearchToState,
      transformer: (events, mapper) =>
          events.debounce(const Duration(seconds: 1)).asyncExpand(mapper),
    );
    on<SearchUserOpenRoom>(_mapSearchUserOpenRoomToState);
  }
  FutureOr<void> _mapSearchUserLoadToState(
      SearchUserLoad event, Emitter<SearchUserState> emit) async {
    emit(SearchUserLoading());
    try {
      List<UserActiveEntity> listfriend = await _iUserRepository.getUserFriends(
          event.startIndex, event.number, null);
      emit(SearchUserLoadSuccess(listFriend: listfriend));
    } catch (e) {
      emit(SearchUserLoadFail());
      print("ERROR LOAD FRIEND: " + e.toString());
    }
  }

  FutureOr<void> _mapSearchUserSearchToState(
      SearchUserSearch event, Emitter<SearchUserState> emit) async {
    emit(SearchUserLoading());
    print('on search bloc');
    try {
      List<UserActiveEntity> listfriend = await _iUserRepository.getUserFriends(
          event.startIndex, event.number, event.searchvalue);
      emit(SearchUserSucess(listFriend: listfriend));
    } catch (e) {
      emit(SearchUserLoadFail());
      print("ERROR LOAD FRIEND: " + e.toString());
    }
  }

  FutureOr<void> _mapSearchUserOpenRoomToState(
      SearchUserOpenRoom event, Emitter<SearchUserState> emit) async {
        emit(SearchUserLoading());
    try {
      final RoomOverviewEntity roomEntity =
          await _iRoomRepository.findPrivateRoomsByUserId(event.otherUser);
      emit(SearchUserOpenRoomComplete(roomEntity: roomEntity));
    } catch (e) {
      emit(SearchUserOpenRoomComplete(
          roomEntity: RoomOverviewEntity(
        id: "-1",
        joiners: [],
        name: 'Phòng mới',
        lastMessage: null,
        type: 'private',
        avatarUrl: null,
      )));
    }
  }
}
