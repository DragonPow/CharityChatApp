part of 'make_name_group_bloc.dart';

abstract class MakeNameGroupState {
  const MakeNameGroupState();

}

class MakeNameGroupInitial extends MakeNameGroupState {}
class MakeNameGroupRemoveMemSuccess extends MakeNameGroupState {
  final List<UserActiveEntity> listMember;
  const MakeNameGroupRemoveMemSuccess({Key? key, required this.listMember});
}

class MakeNameGroupChoiceAvatarSuccess extends MakeNameGroupState{
  final File avatar;
  const MakeNameGroupChoiceAvatarSuccess( {Key? key, required this.avatar});
}

class MakeNameGroupCreateLoading extends MakeNameGroupState {}
class MakeNameGroupCreateSuccess extends MakeNameGroupState{
  final RoomOverviewEntity roomEntity;
  const MakeNameGroupCreateSuccess({Key? key, required this.roomEntity});
}
class MakeNameGroupCreateFail extends MakeNameGroupState{}

