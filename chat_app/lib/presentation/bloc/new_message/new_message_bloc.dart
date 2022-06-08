import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/entities/user_active_entity.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'new_message_event.dart';
part 'new_message_state.dart';

class NewMessageBloc extends Bloc<NewMessageEvent, NewMessageState> {
  final IUserRepository _iUserRepository;
  NewMessageBloc(this._iUserRepository) : super(NewMessageInitial()) {
    on<NewMessageLoad>(_mapNewMessageEventToSTate);
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
}
