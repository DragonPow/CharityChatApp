import 'package:chat_app/domain/entities/room_entity.dart';
import 'package:tuple/tuple.dart';

import '../entities/message_entity.dart';

abstract class IChatRepository {
  Future<List<MessageEntity>> getMessages(
      int roomId, int startIndex, int number);
  Future<List> getImages(int roomId, int startIndex, int number);
  Future<List> getFiles(int roomId, int startIndex, int number);

  Future<void> sendMessage(MessageEntity message);
  Future<void> sendImages(List<MessageEntity> message);
  Future<void> sendFile(MessageEntity message);

  Future<Tuple2<List<RoomEntity>, int>> findMessagesByContent(
      String roomId, String textMatch);

  Future<bool> create(MessageEntity message);
  Future<bool> delete(String messageId);
  Future<bool> deleteAll(String roomId);
}
