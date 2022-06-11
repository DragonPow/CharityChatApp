import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/repositories/authenticate_repository.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:chat_app/utils/local_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../dependencies_injection.dart';

part 'main_bloc_event.dart';
part 'main_bloc_state.dart';

class MainBlocBloc extends Bloc<MainBlocEvent, MainBlocState> {
  final IAuthenticateRepository _iAuthenticateRepository;
    final _localStorage = sl<LocalStorageService>();

  MainBlocBloc(this._iAuthenticateRepository) : super(MainBlocInitial()) {
    on<MainBlocCheck>(_mapMainBlocCheckToState);
    on<MainBlocLogin>(_mapMainBlocLoginToState);
    on<MainBlocLogout>(_mapMainBlocLogoutToState);

  }

  FutureOr<void> _mapMainBlocCheckToState(
      MainBlocCheck event, Emitter<MainBlocState> emit) async {
    final json = await _localStorage.getUsernameAndPass();
    if (json["username"] == null || json["password"] == null) {
      emit(MainBlocNotYetLogin());
    } else {
      try {
        final login = await _iAuthenticateRepository.logIn(
            json["username"]!, json["password"]!);
        // final login = await _iAuthenticateRepository.logIn(
        //     nametest, passtest);
        if(login != null){
          emit(MainBlocAlreadyLogin());
        }
        else{
            emit(MainBlocNotYetLogin());
        }
      } catch (e) {
        print("ERROR CHECK USER ADREADY LOGIN?");
        print(e);
      }
    }
  }

  FutureOr<void> _mapMainBlocLoginToState(
      MainBlocLogin event, Emitter<MainBlocState> emit) async {
    emit(MainBlocAlreadyLogin());
  }

  FutureOr<void> _mapMainBlocLogoutToState(MainBlocLogout event, Emitter<MainBlocState> emit) {
    _iAuthenticateRepository.logOut();
  }
}
