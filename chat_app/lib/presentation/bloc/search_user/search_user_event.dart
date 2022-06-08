part of 'search_user_bloc.dart';

abstract class SearchUserEvent extends Equatable {
  const SearchUserEvent();

  @override
  List<Object> get props => [];
}

class SearchUserLoad extends SearchUserEvent {
  final int startIndex;
  final int number;
  const SearchUserLoad(
      {Key? key, required this.number, required this.startIndex});
}

class SearchUserSearch extends SearchUserLoad {
  final String searchvalue;
  const SearchUserSearch(
      {required int number, required int startIndex, required this.searchvalue})
      : super(number: number, startIndex: startIndex);
}
