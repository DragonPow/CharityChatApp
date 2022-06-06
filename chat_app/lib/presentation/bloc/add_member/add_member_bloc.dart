import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/user_active_entity.dart';

part 'add_member_event.dart';
part 'add_member_state.dart';

class AddMemberBloc extends Bloc<AddMemberEvent, AddMemberState> {
  final IUserRepository _iUserRepository;
  AddMemberBloc(this._iUserRepository) : super(AddMemberInitial()) {
    on<AddMemberLoadSuggest>(_mapAddMemberLoadToState);
    on<AddMemberAdd>(_mapAddMemberAddToState);
    on<AddMemberRemove>(_mapAddMemberRemoveToState);
  }
  FutureOr<void> _mapAddMemberLoadToState(
      AddMemberLoadSuggest event, Emitter<AddMemberState> emit) async {
    emit(AddMemberLoading());
    try {
      List<UserActiveEntity> listFriend =
          await _iUserRepository.getUserFriends(0, 10);

      emit(AddMemberLoadSuccess(friendUsers: listFriend, members: []));
      // emit(AddMemberInitial());
    } catch (e) {
      emit(AddMemberLoadFail());
      print("Error load user friend" + e.toString());
    }
  }

  FutureOr<void> _mapAddMemberAddToState(
      AddMemberAdd event, Emitter<AddMemberState> emit) async {
    emit(AddMemberAddMemSuccess(
        friendUsers: [...event.listFriend..removeWhere((element) => element == event.member)],
        members: [...event.listMember..add(event.member)]));
  }

  FutureOr<void> _mapAddMemberRemoveToState(
      AddMemberRemove event, Emitter<AddMemberState> emit) async {
    emit(AddMemberRemoveMemSuccess(
        friendUsers: event.listFriend..add(event.member),
        members: event.listMember..removeWhere((element) => element == event.member)));
  }
}
