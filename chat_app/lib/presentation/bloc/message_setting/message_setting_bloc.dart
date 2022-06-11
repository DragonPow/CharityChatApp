import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
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
  MessageSettingBloc(this._chatRepository)
      : super(const MessageSettingState()) {
    on<MessageSettingLoadImageFile>(
      _mapMessageSettingLoadImageFileToState,
      transformer: sequential(),
    );
    on<MessageSettingFindMessage>(_mapMessageSettingFindMessageToState);
    on<MessageSettingFindNameAlias>(_mapMessageSettingFindNameAliasToState);
    on<MessageSettingChangeNameAlias>(_mapMessageSettingChangeNameAliasToState);
    on<MessageSettingUpdateJoiners>(_mapMessageSettingUpdateJoinersToState);
  }

  _combineImage(List source, List desc) {
    final newSource = [...source]
      ..retainWhere((element) => !desc.any((i) => i['id'] == element['id']));
    return [...newSource, ...desc];
  }

  FutureOr<void> _mapMessageSettingLoadImageFileToState(
      MessageSettingLoadImageFile event,
      Emitter<MessageSettingState?> emit) async {
    // Find current image and file
    final currentImages = state is MessageSettingImageFileState
        ? (state as MessageSettingImageFileState).imagesUri
        : [];
    final currentFiles = state is MessageSettingImageFileState
        ? (state as MessageSettingImageFileState).files
        : [];

    if (state is MessageSettingImageFileState) {
      final current = state as MessageSettingImageFileState;
      emit(MessageSettingImageFileState(
        imagesUri: currentImages,
        files: currentFiles,
        isImageFull: current.isImageFull,
        isFileFull: current.isFileFull,
        isLoading: true,
        error: null,
      ));
    } else {
      emit(
        const MessageSettingImageFileState.initial().copyWith(isLoading: true),
      );
    }

    isLoadImage() => event.typeLoad == 'image';

    try {
      final rs = isLoadImage()
          ? await _chatRepository.getImages(
              event.roomId,
              event.startIndex,
              event.number,
            )
          : await _chatRepository.getFiles(
              event.roomId,
              event.startIndex,
              event.number,
            );

      emit(MessageSettingImageFileState(
        imagesUri:
            isLoadImage() ? _combineImage(currentImages, rs) : currentImages,
        isImageFull: isLoadImage()
            ? (rs.length < event.number)
            : state is MessageSettingImageFileState
                ? (state as MessageSettingImageFileState).isImageFull
                : false,
        files: !isLoadImage() ? _combineImage(currentFiles, rs) : currentFiles,
        isFileFull: !isLoadImage()
            ? (rs.length < event.number)
            : state is MessageSettingImageFileState
                ? (state as MessageSettingImageFileState).isFileFull
                : false,
        isLoading: false,
        error: null,
      ));
    } catch (error) {
      log('Load image fail');
      print(error);
      emit(MessageSettingImageFileState(
        imagesUri: currentImages,
        files: currentFiles,
        isImageFull: state is MessageSettingImageFileState
            ? (state as MessageSettingImageFileState).isImageFull
            : false,
        isFileFull: state is MessageSettingImageFileState
            ? (state as MessageSettingImageFileState).isFileFull
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

  FutureOr<void> _mapMessageSettingUpdateJoinersToState(
      MessageSettingUpdateJoiners event, Emitter<MessageSettingState> emit) {}
}
