part of 'active_user_bloc.dart';

abstract class ActiveUserEvent extends Equatable {
  const ActiveUserEvent();

  @override
  List<Object> get props => [];
}

class ActiveUserLoadEvent extends ActiveUserEvent{
  final int startIndex;
  final int number;
  const ActiveUserLoadEvent({Key?key, required this.number, required this.startIndex});
}


