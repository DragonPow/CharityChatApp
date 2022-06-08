part of 'chat_overview_bloc.dart';

class ChatOverviewState extends Equatable {
  ChatOverviewState({
    required List<RoomOverviewEntity> listRoom,
    required this.isLoading,
    required this.error,
    required this.isFull,
  }) : _listRoom = {for (var i in listRoom) i.id: i} {
    listSortedRoom = [..._listRoom.values.toList()]
      ..sort((a, b) => a.lastMessage == null
          ? 1
          : b.lastMessage == null
              ? -1
              : a.lastMessage!.timeCreate.compareTo(b.lastMessage!.timeCreate) *
                  -1);
  }

  ChatOverviewState.initial()
      : this(
          listRoom: const [],
          isLoading: false,
          error: null,
          isFull: false,
        );

  final Map<String, RoomOverviewEntity> _listRoom;
  final bool isLoading;
  final bool isFull;
  final Object? error;

  late final List<RoomOverviewEntity> listSortedRoom;

  @override
  List<Object?> get props => [_listRoom, isLoading, error, isFull];
}
