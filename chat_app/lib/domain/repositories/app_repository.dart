import 'package:chat_app/domain/entities/room_entity.dart';

import '../entities/user_active_entity.dart';

abstract class IAppRepository {
  Future<List<UserActiveEntity>> getActiveUsers(int startIndex, int number);
  Future<List<RoomEntity>> getRooms(int startIndex, int number);
}