import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/entities/user_active_entity.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'search_user_event.dart';
part 'search_user_state.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  final IUserRepository _iUserRepository;
  SearchUserBloc(this._iUserRepository) : super(SearchUserInitial()) {
    on<SearchUserLoad>(_mapSearchUserLoadToState);
    on<SearchUserSearch>(_mapSearchUserSearchToState);
  }
  FutureOr<void> _mapSearchUserLoadToState (SearchUserLoad event, Emitter<SearchUserState> emit) async{
    emit(SearchUserLoading());
    try{
      List<UserActiveEntity> listfriend = await _iUserRepository.getUserFriends(event.startIndex, event.number, null);
      emit(SearchUserLoadSuccess(listFriend: listfriend));
    }
    catch (e){
      emit(SearchUserLoadFail());
      print("ERROR LOAD FRIEND: " + e.toString() );

    }
  }

  FutureOr<void> _mapSearchUserSearchToState(SearchUserSearch event, Emitter<SearchUserState> emit) async{
    emit(SearchUserLoading());
    try{
      List<UserActiveEntity> listfriend = await _iUserRepository.getUserFriends(event.startIndex, event.number, event.searchvalue);
      emit(SearchUserLoadSuccess(listFriend: listfriend));
    }
    catch (e){
      emit(SearchUserLoadFail());
      print("ERROR LOAD FRIEND: " + e.toString() );

    }
  }
}
