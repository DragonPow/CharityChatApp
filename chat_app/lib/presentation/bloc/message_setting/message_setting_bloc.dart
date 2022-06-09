import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:chat_app/domain/entities/user_message_entity.dart';
import 'package:chat_app/domain/repositories/chat_repository.dart';
import 'package:chat_app/domain/repositories/room_repository.dart';
import 'package:equatable/equatable.dart';

part 'message_setting_event.dart';
part 'message_setting_state.dart';

class MessageSettingBloc
    extends Bloc<MessageSettingEvent, MessageSettingState> {
  final IChatRepository _chatRepository;
  MessageSettingBloc(this._chatRepository) : super(const MessageSettingState()) {
    on<MessageSettingLoadImages>(_mapMessageSettingLoadImagesToState);
    on<MessageSettingFindMessage>(_mapMessageSettingFindMessageToState);
    on<MessageSettingFindNameAlias>(_mapMessageSettingFindNameAliasToState);
    on<MessageSettingChangeNameAlias>(_mapMessageSettingChangeNameAliasToState);
    on<MessageSettingUpdateJoiners>(_mapMessageSettingUpdateJoinersToState);
  }

  _combineImage(List source, List desc) {
    final newSource = [...source]
      ..retainWhere((element) => !desc.any((i) => i['id'] == element['id']));
    return [...newSource, desc];
  }

  FutureOr<void> _mapMessageSettingLoadImagesToState(
      MessageSettingLoadImages event,
      Emitter<MessageSettingState?> emit) async {
    final currentImages = state is MessageSettingImageState
        ? (state as MessageSettingImageState).imagesUri
        : [];

    if (state is MessageSettingImageState) {
      final imageState = state as MessageSettingImageState;
      emit(MessageSettingImageState(
        imagesUri: currentImages,
        isFull: imageState.isFull,
        isLoading: true,
        error: null,
      ));
    } else {
      emit(MessageSettingImageState(
        imagesUri: currentImages,
        isFull: false,
        isLoading: true,
        error: null,
      ));
    }
    
    try {
      final rs = await _chatRepository.getImages(
        event.roomId,
        event.startIndex,
        event.number,
      );
      emit(MessageSettingImageState(
        imagesUri: _combineImage(currentImages, rs),
        isFull: rs.length < event.number,
        isLoading: false,
        error: null,
      ));
    } catch (error) {
      log('Load image fail');
      emit(MessageSettingImageState(
        imagesUri: currentImages,
        isFull: state is MessageSettingImageState
            ? (state as MessageSettingImageState).isFull
            : false,
        isLoading: false,
        error: error,
      ));
    }
  }

  FutureOr<void> _mapMessageSettingFindMessageToState(
      MessageSettingFindMessage event, Emitter<MessageSettingState?> emit) {}

  FutureOr<void> _mapMessageSettingFindNameAliasToState(
      MessageSettingFindNameAlias event, Emitter<MessageSettingState?> emit) {}

  FutureOr<void> _mapMessageSettingChangeNameAliasToState(
      MessageSettingChangeNameAlias event,
      Emitter<MessageSettingState?> emit) {}

  FutureOr<void> _mapMessageSettingUpdateJoinersToState(MessageSettingUpdateJoiners event, Emitter<MessageSettingState> emit) {
  }
}
