import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/entities/room_overview_entity.dart';
import 'package:chat_app/domain/repositories/room_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

part 'chat_overview_event.dart';
part 'chat_overview_state.dart';

class ChatOverviewBloc extends Bloc<ChatOverviewEvent, ChatOverviewState> {
  final IRoomRepository _roomRepository;
  ChatOverviewBloc(this._roomRepository) : super(ChatOverviewInitial()) {
    on<ChatOverviewEvent>(_mapChatOverViewEventToState);
  }

  FutureOr<void> _mapChatOverViewEventToState (ChatOverviewEvent event, Emitter<ChatOverviewState> emit) async{
      emit(ChatOverviewLoading());
      try{
        List<RoomOverviewEntity> listRoomOverview = await _roomRepository.getRoomOverviews(2, 0, 10);
        emit(ChatOverviewLoadSuccess(listRoomOverview: listRoomOverview));
      }
      catch(e){
        emit(ChatOverviewLoadFail());
      }
  }
}
