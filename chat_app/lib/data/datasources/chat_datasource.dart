import 'package:tuple/tuple.dart';

import '../models/message_model.dart';
import '../models/room_model.dart';

abstract class IChatLocalDataSource
    implements ISendMessage, IGetMessage, ISearchMessage {}

abstract class IChatRemoteDataSource
    implements IChatLocalDataSource, IModifiedMessage {}

abstract class ISearchMessage {
  Future<Tuple2<List<RoomModel>, int>> findMessagesByContent(
      String roomId, String textMatch);
}

abstract class IModifiedMessage {
  Future<String?> createMessage(MessageModel message);
  Future<bool> deleteMessage(String messageId);
  Future<bool> deleteAllMessageInRoom(String roomId);
}

abstract class ISendMessage {
  Future<String?> sendMessageToRoom(MessageModel message);
  Future<String?> sendImagesToRoom(List<MessageModel> message);
  Future<String?> sendFileToRoom(MessageModel message);
}

abstract class IGetMessage {
  Future<List<MessageModel>> getMessagesInRoom(
      String roomId, int startIndex, int number);
  Future<List> getImagesInRoom(String roomId, int startIndex, int number);
  Future<List> getFilesInRoom(String roomId, int startIndex, int number);
}
