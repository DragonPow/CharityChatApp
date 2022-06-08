part of 'make_name_group_bloc.dart';

abstract class MakeNameGroupEvent extends Equatable {
  const MakeNameGroupEvent();

  @override
  List<Object> get props => [];
}

class MakeNameGroupRemoveMem extends MakeNameGroupEvent{
  final List<UserActiveEntity> listMember;
  final UserActiveEntity removedMember;
  const MakeNameGroupRemoveMem({Key? key, required this.listMember, required this.removedMember});
}
class MakeNameGroupChoiceAvatar extends MakeNameGroupEvent{
  final File avatar;
  const MakeNameGroupChoiceAvatar({Key? key, required this.avatar});
}
class MakeNameGroupCreate extends MakeNameGroupEvent{
  final RoomEntity room;
  final File? avatar;

  const MakeNameGroupCreate ({Key? key, required this.avatar, required this.room});
}
