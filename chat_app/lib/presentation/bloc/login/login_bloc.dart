import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../dependencies_injection.dart';
import '../../../domain/repositories/authenticate_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final IUserRepository _iUserRepository;
  LoginBloc(this._iUserRepository) : super(LoginInitial()) {
    on<LoginPageLogin>(_mapLoginPageLoginToState);
  }
  FutureOr<void> _mapLoginPageLoginToState(
      LoginPageLogin event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final token =
          await sl<IAuthenticateRepository>().logIn(event.email, event.pass);
      if (token == null) {
        emit(LoginWrongPassOrEmail());
      } else {
        emit(LoginSuccess());
      }
    } catch (e) {
      emit(LoginErrorNetWork());
    }
  }
}
