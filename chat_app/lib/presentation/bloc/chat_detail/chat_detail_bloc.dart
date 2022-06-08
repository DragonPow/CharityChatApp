import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:chat_app/helper/enum.dart';
import 'package:chat_app/helper/helper.dart';
import 'package:chat_app/helper/network/socket_service.dart';
import 'package:chat_app/modelsclone/messages.dart';
import 'package:chat_app/utils/account.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../dependencies_injection.dart';
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
  late StreamController<List<MessageEntity>> _streamChat;
  // get streamChat => _streamChat.stream;

  ChatDetailBloc({required this.chatRepository})
      : super(ChatDetailState.initial()) {
    on<ChatDetailLoadInit>(_mapChatDetailLoadInitToState);
    on<ChatDetailLoad>(
      _mapChatDetailLoadToState,
      transformer: throttleDroppable(throttleDuration),
    );
    on<ChatDetailSend>(
      _mapChatDetailSendToState,
      transformer: concurrent(),
    );
    on<ChatDetailReceive>(
      _mapChatDetailReceiveToState,
      transformer: concurrent(),
    );
  }

  void dispose() {
    log('Dispose chat detail bloc');
    _streamChat.close();
  }

  List<MessageEntity> _combineMessages(
      List<MessageEntity> listSource, List<MessageEntity> listDest) {
    listSource.retainWhere((s) => !listDest.any((d) => s.id == d.id));
    return [...listSource, ...listDest];
  }

  _emitIsLoading(ChatDetailEvent event, Emitter<ChatDetailState> emit) {
    emit(ChatDetailState(
      listMessage: state.listSortedMessage,
      isLoading: true,
      isLoadFull: false,
      error: null,
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
        listMessage: _combineMessages(state.listSortedMessage, newMessages),
        isLoading: false,
        isLoadFull: isFull,
        error: null,
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

    final isFile = event.content == null;
    final type = isFile ? getTypeOfFile(event.file!) : 'text';
    final creator = Account.getUserEntity()!;

    final newMessage = MessageEntity.send(
      value: isFile ? event.file : event.content,
      type: convertToMessageChatType(type),
      creator: creator,
    );

    final newList = _combineMessages(state.listSortedMessage, [newMessage]);

    try {
      emit(ChatDetailState(
        listMessage: newList,
        isLoading: true,
        error: state.error,
        isLoadFull: state.isLoadFull,
      ));

      final rs = await chatRepository.sendMessage(
        event.content,
        event.roomId,
        event.file,
      );

      print('MESSAGE SEND');
      newList.remove(newMessage);

      emit(ChatDetailState(
        listMessage: _combineMessages(
          newList,
          [
            newMessage.copyWith(
              id: rs['message']['id'],
              state: MessageState.normal,
            )
          ],
        ),
        isLoading: false,
        error: state.error,
        isLoadFull: state.isLoadFull,
      ));
    } catch (e) {
      print("Sent message failed" + e.toString());
      emit(ChatDetailState(
        listMessage: _combineMessages(
            newList, [newMessage.copyWith(state: MessageState.error)]),
        isLoading: false,
        error: e,
        isLoadFull: state.isLoadFull,
      ));
    }
  }

  // void _NewMessage(List<MessageEntity> messages) {
  //   print('On new message add');
  //   emit(ChatDetailState(
  //       listMessage: _combineMessages(state.listSortedMessage, messages),
  //       isLoading: state.isLoading));
  // }

  FutureOr<void> _mapChatDetailLoadInitToState(
      ChatDetailLoadInit event, Emitter<ChatDetailState> emit) {
    add(ChatDetailLoad(number: 10, roomId: event.roomId, startIndex: 0));
    _streamChat = chatRepository.getStreamNewMessage();
    _streamChat.stream.listen((messages) {
      // _NewMessage(messages);
      add(ChatDetailReceive(newList: messages));
    });
  }

  FutureOr<void> _mapChatDetailReceiveToState(
      ChatDetailReceive event, Emitter<ChatDetailState> emit) {
    print('On new message add');
    emit(ChatDetailState(
      listMessage: _combineMessages(
          state.listSortedMessage,
          event.newList),
      isLoading: state.isLoading,
      error: state.error,
      isLoadFull: state.isLoadFull,
    ));
  }
}
