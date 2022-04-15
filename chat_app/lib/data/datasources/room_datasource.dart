import 'package:chat_app/data/models/room_model.dart';

abstract class IRoomLocalDataSource implements IGetRoom, ISearchRoom {}

abstract class IRoomRemoteDataSource
    implements IRoomLocalDataSource, IModifiedRoom, IModifiedUserRoom {}

abstract class ISearchRoom {
  Future<List<RoomModel>> findRoomsByName(String textMatch);
}

abstract class IGetRoom {
  Future<List<RoomModel>> getRoomsByName(int startIndex, int number);
}

abstract class IModifiedRoom {
  Future<String?> createRoom(RoomModel room);
  Future<bool> deleteRoom(String roomId);
  Future<bool> changeNameRoom(String roomId, String newName);
  Future<String?> changeAvatarRoom(String roomId, String avatarData);
}

abstract class IModifiedUserRoom {
  Future<bool> addUserToRoom(String roomId, String userId);
  Future<bool> removeUserFromRoom(String roomId, String userId);
}
