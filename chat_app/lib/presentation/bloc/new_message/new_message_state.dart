part of 'new_message_bloc.dart';

abstract class NewMessageState extends Equatable {
  const NewMessageState();
  
  @override
  List<Object> get props => [];
}

class NewMessageInitial extends NewMessageState {}
class NewMessageLoading extends NewMessageState {}
class NewMessageLoadFail extends NewMessageState {}
class NewMessageLoadSuccess extends NewMessageState {
  final List<UserActiveEntity> friendUsers;
  const NewMessageLoadSuccess({Key? key, required this.friendUsers});
}
