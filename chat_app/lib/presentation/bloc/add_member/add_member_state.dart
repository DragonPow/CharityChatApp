part of 'add_member_bloc.dart';

abstract class AddMemberState {
  const AddMemberState();
  
  @override
  List<Object?> get props => [];
}

class AddMemberInitial extends AddMemberState {}
class AddMemberLoading extends AddMemberState {}
class AddMemberLoadFail extends AddMemberState {}
class AddMemberLoadSuccess extends AddMemberState {
  final List<UserActiveEntity> friendUsers;
  final List<UserActiveEntity> members;
  const AddMemberLoadSuccess({Key? key, required this.friendUsers, required this.members});
}
class AddMemberAddMemSuccess extends AddMemberLoadSuccess{
  const AddMemberAddMemSuccess({required List<UserActiveEntity> friendUsers, required List<UserActiveEntity> members}) : super(friendUsers: friendUsers, members: members);
}
class AddMemberRemoveMemSuccess extends AddMemberLoadSuccess{
  const AddMemberRemoveMemSuccess({required List<UserActiveEntity> friendUsers, required List<UserActiveEntity> members}) : super(friendUsers: friendUsers, members: members);
}







