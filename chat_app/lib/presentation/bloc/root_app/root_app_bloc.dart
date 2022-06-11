import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'root_app_event.dart';
part 'root_app_state.dart';

class RootAppBloc extends Bloc<RootAppEvent, RootAppState> {
  RootAppBloc() : super(RootAppInitial()) {
    on<RootAppChangeTap>(_mapRootAppEventToState);
  }

  FutureOr<void> _mapRootAppEventToState(RootAppChangeTap event, Emitter<RootAppState> emit) async{
    emit(RootAppChangeTapSuccess(tap: event.tap));
  }
}
