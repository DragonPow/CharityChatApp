part of 'active_user_bloc.dart';

abstract class ActiveUserState extends Equatable {
  const ActiveUserState();
  
  @override
  List<Object> get props => [];
}

class ActiveUserInitial extends ActiveUserState {}
class ActiveUserLoading extends ActiveUserState {}
class ActiveUserLoadSuccess extends ActiveUserState {
  final List<UserActiveEntity> listUserActive;
  const ActiveUserLoadSuccess({Key?key, required this.listUserActive});
}
class ActiveUserLoadFail extends ActiveUserState {}

