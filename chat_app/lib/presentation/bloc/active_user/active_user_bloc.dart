import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/user_active_entity.dart';

part 'active_user_event.dart';
part 'active_user_state.dart';

class ActiveUserBloc extends Bloc<ActiveUserEvent, ActiveUserState> {
  final IUserRepository _iUserRepository;
  ActiveUserBloc(this._iUserRepository) : super(ActiveUserInitial()) {
    on<ActiveUserLoadEvent>(_mapActiveUserLoadEventToState);
  }

  FutureOr<void> _mapActiveUserLoadEventToState(
      ActiveUserLoadEvent event, Emitter<ActiveUserState> emit) async {
    emit(ActiveUserLoading());
    try {
      List<UserActiveEntity> listUserActive =
          await _iUserRepository.getActiveUsers(0, 10);
      emit(ActiveUserLoadSuccess(listUserActive: listUserActive));
    } catch (e) {
      print("Error load Activeuser: " + e.toString());
    }
  }
}
