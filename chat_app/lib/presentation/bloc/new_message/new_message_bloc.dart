import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/entities/base_user_entity.dart';
import 'package:chat_app/domain/entities/room_overview_entity.dart';
import 'package:chat_app/domain/entities/user_active_entity.dart';
import 'package:chat_app/domain/repositories/room_repository.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'new_message_event.dart';
part 'new_message_state.dart';

class NewMessageBloc extends Bloc<NewMessageEvent, NewMessageState> {
  final IUserRepository _iUserRepository;
  final IRoomRepository _iRoomRepository;
  NewMessageBloc(this._iUserRepository, this._iRoomRepository) : super(NewMessageInitial()) {
    on<NewMessageLoad>(_mapNewMessageEventToSTate);
    on<NewMessageOpenRoom> (_mapNewMessageOpenRoomToState);
  }

  FutureOr<void> _mapNewMessageEventToSTate (NewMessageLoad event, Emitter<NewMessageState> emit ) async{
    emit(NewMessageLoading());
    try{
      List<UserActiveEntity> listFriend = await _iUserRepository.getUserFriends(0, 10, null);
      emit(NewMessageLoadSuccess(friendUsers: listFriend));
    }
    catch(e){
       emit(NewMessageLoadFail());
      print("Error load user friend" + e.toString());
    }
  }

  FutureOr<void> _mapNewMessageOpenRoomToState (NewMessageOpenRoom event, Emitter<NewMessageState> emit) async{
    try{
        final RoomOverviewEntity roomOverviewEntity = await _iRoomRepository.findPrivateRoomsByUserId(event.otherUser);
        emit(NewMessageOpenRoomSuccess(roomOverviewEntity: roomOverviewEntity));
    }
    catch(e){
      emit(NewMessageOpenRoomFail());
      print("ERROR OPEN PRIVATE ROOM");
    }
  }
}
