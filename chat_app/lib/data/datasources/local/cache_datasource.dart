import '../../models/message_model.dart';
import '../../models/room_model.dart';

abstract class ICacheDataSource {
  Future<void> cacheRooms(List<RoomModel> rooms);
  Future<void> cacheMessage(String roomId, List<MessageModel> messages);
}
