import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:chat_app/domain/entities/user_message_entity.dart';
import 'package:chat_app/domain/repositories/chat_repository.dart';
import 'package:chat_app/helper/enum.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatLoaded> {
  final IChatRepository chatRepository;
  ChatBloc({required this.chatRepository})
      : super(const ChatLoaded(messages: [])) {
    on<LoadChat>(onLoadChat);
    on<LoadFilesChat>((event, emit) async {});
    on<LoadImagesChat>((event, emit) async {});
    on<SendMessage>(onSendMessage);
    on<FindChatByContent>(onFindChatByContent);
  }

  FutureOr<void> onSendMessage(event, emit) async {
    final newMessage = MessageEntity.sending(
        content: event.content,
        type: event.type,
        creator: UserMessageEntity(id: '', name: '', avatarUri: ''));
    try {
      emit(state..messagesSending.add(newMessage));
  
      final success = await chatRepository.create(newMessage);
  
      if (success) emit(state..messagesSending.remove(newMessage));
    } catch (e) {
      emit(ChatLoadFail.clone(state).copyWith(error: e));
    }
  }

  FutureOr<void> onFindChatByContent(event, emit) async {
    try {
      emit(ChatLoadInProcess.clone(state));
      final rs = await chatRepository.findMessagesByContent(
          event.roomId, event.textMatch);

      final newChats = rs.item1;
      // ? What is count;
      final count = rs.item2;
      newChats.addAll(
          state.messages..removeWhere((message) => newChats.contains(message)));

      emit(ChatLoaded.clone(state).copyWith(messages: newChats));
    } catch (e) {
      emit(ChatLoadFail.clone(state).copyWith(error: e));
    }
  }

  FutureOr<void> onLoadChat(event, emit) async {
    try {
      emit(ChatLoadInProcess.clone(state));

      final newChats = await chatRepository.getMessages(
          event.roomId, event.startIndex, event.number);
      newChats.addAll(
          state.messages..removeWhere((message) => newChats.contains(message)));

      emit(ChatLoaded.clone(state).copyWith(messages: newChats));
    } catch (e) {
      emit(ChatLoadFail.clone(state).copyWith(error: e));
    }
  }
}
