import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:chat_app/helper/enum.dart';
import 'package:chat_app/helper/helper.dart';
import 'package:chat_app/modelsclone/messages.dart';
import 'package:chat_app/utils/account.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../domain/repositories/chat_repository.dart';

part 'chat_detail_event.dart';
part 'chat_detail_state.dart';

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ChatDetailBloc extends Bloc<ChatDetailEvent, ChatDetailState> {
  static const throttleDuration = Duration(seconds: 1);
  final IChatRepository chatRepository;

  ChatDetailBloc({required this.chatRepository})
      : super(ChatDetailState.initial()) {
    on<ChatDetailLoad>(
      _mapChatDetailLoadToState,
      transformer: throttleDroppable(throttleDuration),
    );
    on<ChatDetailSend>(
      _mapChatDetailSendToState,
      transformer: concurrent(),
    );
  }

  _emitIsLoading(ChatDetailEvent event, Emitter<ChatDetailState> emit) {
    emit(ChatDetailState(
      listMessage: state.listSortedMessage,
      isLoading: true,
    ));
  }

  _emitFail(ChatDetailEvent event, Emitter<ChatDetailState> emit, Object e) {
    print(e);
    emit(ChatDetailState(
      listMessage: state.listSortedMessage,
      isLoading: false,
      error: e,
      isLoadFull: state.isLoadFull,
    ));
  }

  FutureOr<void> _mapChatDetailLoadToState(
      ChatDetailLoad event, Emitter<ChatDetailState> emit) async {
    if (state.isLoadFull) {
      return;
    }
    _emitIsLoading(event, emit);
    try {
      bool isFull = false;

      final newMessages = await chatRepository.getMessages(
          event.roomId, event.startIndex, event.number);
      if (newMessages.length < event.number) {
        isFull = true; // if true, no new image for load
      }
      print('MESSAGE LOADED');
      print(messages);

      emit(ChatDetailState(
        listMessage: [...state.listSortedMessage, ...newMessages],
        isLoading: false,
        isLoadFull: isFull,
      ));
    } catch (e) {
      print("Error when load detail message:");
      _emitFail(event, emit, e);
    }
  }

  FutureOr<void> _mapChatDetailSendToState(
      ChatDetailSend event, Emitter<ChatDetailState> emit) async {
    if (event.content == null && event.file == null) {
      print('Bắt buộc phải chứa 1 trong 2');
      return;
    }
    if (Account.instance == null) {
      print('bắt buộc phải đăng nhập');
      return;
    }

    final isFile = event.content != null;
    final type = isFile ? getTypeOfFile(event.file!) : 'text';
    final creator = Account.getUserEntity()!;
    final indexAddNewMessage = 0;

    final newMessage = MessageEntity.send(
      value: isFile ? event.file : event.content,
      type: convertToMessageChatType(type),
      creator: creator,
    );

    final newList = [
      ...state.listSortedMessage..insert(indexAddNewMessage, newMessage)
    ];

    try {
      emit(ChatDetailState(
        listMessage: newList,
        isLoading: true,
      ));

      final rs = await chatRepository.sendMessage(
          event.content, event.roomId, event.file);

      print('MESSAGE SEND');
      print(messages);

      emit(ChatDetailState(
        listMessage: newList
          ..replaceRange(
            indexAddNewMessage,
            indexAddNewMessage + 1,
            [newMessage.copyWith(state: MessageState.error)],
          ),
        isLoading: false,
        isLoadFull: state.isLoadFull,
      ));
    } catch (e) {
      print("Sent message failed" + e.toString());
      emit(ChatDetailState(
        listMessage: newList
          ..replaceRange(
            indexAddNewMessage,
            indexAddNewMessage + 1,
            [newMessage.copyWith(state: MessageState.error)],
          ),
        isLoading: false,
        error: e,
        isLoadFull: state.isLoadFull,
      ));
    }
  }
}
