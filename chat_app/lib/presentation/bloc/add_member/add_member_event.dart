part of 'add_member_bloc.dart';

abstract class AddMemberEvent extends Equatable {
  const AddMemberEvent();

  @override
  List<Object> get props => [];
}
class AddMemberLoadSuggest extends AddMemberEvent{
  final int startIndex;
  final int number;
  const AddMemberLoadSuggest({Key? key, required this.number, required this.startIndex});
}
class AddMemberAdd extends AddMemberEvent{
  final List<UserActiveEntity> listMember;
  final UserActiveEntity member;
  final List<UserActiveEntity> listFriend;
  const AddMemberAdd({Key?key, required this.listMember, required this.member, required this.listFriend});
}
class AddMemberRemove extends AddMemberEvent{
  final List<UserActiveEntity> listMember;
  final UserActiveEntity member;
  final List<UserActiveEntity> listFriend;
  const AddMemberRemove ({Key? key, required this.listMember, required this.member, required this.listFriend});
}