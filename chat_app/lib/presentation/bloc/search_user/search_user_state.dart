part of 'search_user_bloc.dart';

abstract class SearchUserState  {
  const SearchUserState();
  
  @override
  List<Object> get props => [];
}

class SearchUserInitial extends SearchUserState {}


class SearchUserLoadSuccess extends SearchUserState {
  final List<UserActiveEntity> listFriend;
  const SearchUserLoadSuccess( {Key? key, required this.listFriend});
}

class SearchUserLoadFail extends SearchUserState {}

class SearchUserLoading extends SearchUserState {}
class SearchUserSucess extends SearchUserLoadSuccess {
  const SearchUserSucess({required List<UserActiveEntity> listFriend}) : super(listFriend: listFriend);
}
class SearchUserFailed extends SearchUserState {}

class SearchUserOpenRoomComplete extends SearchUserState {
  final RoomOverviewEntity roomEntity;
  const SearchUserOpenRoomComplete({Key? key, required this.roomEntity});
}
class SearchUserOpenRoomFail extends SearchUserState {
}


