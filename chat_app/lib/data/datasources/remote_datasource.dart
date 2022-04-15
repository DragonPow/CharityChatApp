import 'package:chat_app/data/models/message_model.dart';
import 'package:chat_app/data/models/room_model.dart';

import '../models/user_model.dart';

abstract class RemoteDataSource {
  Stream<List<MessageModel>> getMessages(String roomId, int startIndex, int number);
  Stream<List<RoomModel>> getRooms(int startIndex, int number);
  Future<List<UserModel>> getActiveUser(int startIndex, int number);

}