import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:chat_app/modelsclone/messages.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/repositories/chat_repository.dart';

part 'chat_detail_event.dart';
part 'chat_detail_state.dart';


class ChatDetailBloc extends Bloc<ChatDetailEvent, ChatDetailState> {
  final IChatRepository chatRepository;
  ChatDetailBloc({required this.chatRepository}) : super(ChatDetailInitial()) {
    on<ChatDetailLoadMessage>(mapChatDetailLoadToState);
  }

FutureOr<void> mapChatDetailLoadToState(ChatDetailLoadMessage event, Emitter<ChatDetailState> emit) async{
  emit(ChatDetailLoading());
  try{
    List<MessageEntity> listMessage = await chatRepository.getMessages(event.roomId, event.startIndex, event.number);

    emit(ChatDetailLoadSuccess(listMessage: listMessage));
    print(messages);
  }
  catch (e) {
    emit(ChatDetailLoadFail());
    print("Error when load detail message:" + e.toString());
  }
}
}
