part of 'chat_detail_bloc.dart';

class ChatDetailState extends Equatable {
  ChatDetailState({
    Key? key,
    required List<MessageEntity> listMessage,
    required this.isLoading,
    required this.isLoadFull,
    required this.error,
  }) : _listMessage = {for (var i in listMessage) i.id: i};

  ChatDetailState.initial()
      : this(
          listMessage: const [],
          isLoading: false,
          isLoadFull: false,
          error: null,
        );

  final Map<String, MessageEntity> _listMessage;
  final bool isLoading;
  final bool isLoadFull;
  final Object? error;

  late final List<MessageEntity> listSortedMessage = [..._listMessage.values.toList()]
    ..sort((a, b) => a.timeCreate.compareTo(b.timeCreate) * -1);

  @override
  List<Object?> get props => [_listMessage, isLoading, isLoadFull, error];
}
