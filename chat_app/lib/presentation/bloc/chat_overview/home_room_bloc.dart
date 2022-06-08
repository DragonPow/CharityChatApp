import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:chat_app/domain/entities/room_overview_entity.dart';
import 'package:chat_app/domain/repositories/room_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:chat_app/utils/account.dart';
import 'package:stream_transform/stream_transform.dart';

import 'chat_overview_bloc.dart';

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

enum HomeRoomState {
  private,
  group,
}

extension TranferHOmeRoomStateToString on HomeRoomState {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class HomeBlocEvent extends Equatable{
  final HomeRoomState tab;
  final ChatOverviewEvent blocEvent;

  HomeBlocEvent({required this.tab, required this.blocEvent});

  @override
  List<Object?> get props => [tab, blocEvent];
}

class HomeRoomBloc extends Bloc<HomeBlocEvent,
    Map<HomeRoomState, ChatOverviewBloc>> {
  static const throttleDuration = Duration(seconds: 1);

  ChatOverviewState GetStateByTab(HomeRoomState tab) {
    return state[tab]!.state;
  }

  HomeRoomBloc(Map<HomeRoomState, ChatOverviewBloc> homeRoom)
      : super(homeRoom) {
    on<HomeBlocEvent>(
      _mapEventToState,
      transformer: restartable(),
    );
  }

  FutureOr<void> _mapEventToState(
    HomeBlocEvent event,
    Emitter<Map<HomeRoomState, ChatOverviewBloc>> emit,
  ) async {
    state[event.tab]?.add(event.blocEvent);
  }
}
