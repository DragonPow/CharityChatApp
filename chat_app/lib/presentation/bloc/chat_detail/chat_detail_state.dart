part of 'chat_detail_bloc.dart';

class ChatDetailState extends Equatable {
  ChatDetailState({
    Key? key,
    required List<MessageEntity> listMessage,
    required this.isLoading,
    required this.isLoadFull,
    required this.error,
  }) {
    _listMessage = {for (var i in listMessage) i.id: i};
    listSortedMessage = [...listMessage.toList()]
      ..sort((a, b) => a.timeCreate.compareTo(b.timeCreate) * -1);
  }

  ChatDetailState.initial()
      : this(
          listMessage: const [],
          isLoading: false,
          isLoadFull: false,
          error: null,
        );

  late Map<String, MessageEntity> _listMessage;
  final bool isLoading;
  final bool isLoadFull;
  final Object? error;

  late List<MessageEntity> listSortedMessage;

  @override
  List<Object?> get props => [_listMessage, isLoading, isLoadFull, error];
}
