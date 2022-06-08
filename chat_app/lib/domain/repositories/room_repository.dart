import 'dart:io';

import 'package:chat_app/domain/entities/room_overview_entity.dart';

import '../entities/room_entity.dart';

abstract class IRoomRepository {
  Future<List<RoomEntity>> getRooms(int startIndex, int number);
  Future<List<RoomEntity>> findRoomsByName(String textMatch);

  Future<bool> create(RoomEntity room, File? avatar);
  Future<bool> delete(String roomId);
  Future<bool> changeName(String roomId, String newName);
  Future<bool> changeAvatar(String roomId, String avatarData);

  
  Future<bool> addUser(String roomId, String userId);
  Future<bool> removeUser(String roomId, String userId);

  Future<List<RoomOverviewEntity>> getRoomOverviews(String userId , int startIndex, int number,String searchtype);

}
