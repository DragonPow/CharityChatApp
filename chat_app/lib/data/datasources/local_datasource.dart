import 'package:chat_app/data/models/message_model.dart';
import 'package:chat_app/data/models/room_model.dart';

abstract class LocalDataSource {
  Future<List<RoomModel>> getCacheRooms(int startIndex, int number);
  Future<List<MessageModel>> getCacheMessages(String roomId, int startIndex, int number);

  Future<void> cacheRooms(List<RoomModel> rooms);
  Future<void> cacheMessage(String roomId, List<MessageModel> messages);
}