import 'package:chat_app/domain/entities/base_user_entity.dart';
import 'package:chat_app/domain/entities/user_message_entity.dart';

import '../entities/user_active_entity.dart';

abstract class IUserRepository {
    Future<List<UserActiveEntity>> getActiveUsers(int startIndex, int number);
    Future<List<BaseUserEntity>> findUsersByName(String textMatch);
    Future<BaseUserEntity> getUserById(String userId);
    Future<List<UserMessageEntity>> getUsersInRoom(String roomId);
}