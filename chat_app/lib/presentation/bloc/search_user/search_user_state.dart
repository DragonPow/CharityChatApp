part of 'search_user_bloc.dart';

abstract class SearchUserState extends Equatable {
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
class SearchUserSucess extends SearchUserState {}
class SearchUserFailed extends SearchUserState {}
