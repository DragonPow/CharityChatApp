import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/entities/room_entity.dart';
import 'package:chat_app/domain/entities/user_active_entity.dart';
import 'package:chat_app/domain/repositories/room_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../domain/entities/room_overview_entity.dart';

part 'make_name_group_event.dart';
part 'make_name_group_state.dart';

class MakeNameGroupBloc extends Bloc<MakeNameGroupEvent, MakeNameGroupState> {
  final IRoomRepository _iRoomRepository;
  MakeNameGroupBloc(this._iRoomRepository) : super(MakeNameGroupInitial()) {
    on<MakeNameGroupRemoveMem>(_mapMakeNameGroupRemoveMemToState);
    on<MakeNameGroupCreate>(_mapMakeNameGroupCreateToState);
    on<MakeNameGroupChoiceAvatar>(_mapMakeNameGroupChoiceAvatarToState);
  }

  FutureOr<void> _mapMakeNameGroupRemoveMemToState(
      MakeNameGroupRemoveMem event, Emitter<MakeNameGroupState> emit) async {
    emit(MakeNameGroupRemoveMemSuccess(
        listMember: event.listMember
          ..removeWhere((member) => member == event.removedMember)));
  }

  FutureOr<void> _mapMakeNameGroupCreateToState(
      MakeNameGroupCreate event, Emitter<MakeNameGroupState> emit) async {
    emit(MakeNameGroupCreateLoading());
    try {
      RoomOverviewEntity? roomCreate = await _iRoomRepository.create(event.room, event.avatar);
      if (roomCreate != null) {
        emit(MakeNameGroupCreateSuccess(roomEntity: roomCreate));
        emit(MakeNameGroupInitial());
      } else {
        emit(MakeNameGroupCreateFail());
        emit(MakeNameGroupInitial());
      }
    } catch (e) {
      print("ERROR CREATE ROOM" + e.toString());
    }
  }

  FutureOr<void> _mapMakeNameGroupChoiceAvatarToState(
      MakeNameGroupChoiceAvatar event, Emitter<MakeNameGroupState> emit) async {
    emit(MakeNameGroupChoiceAvatarSuccess(avatar: event.avatar));
  }
}
