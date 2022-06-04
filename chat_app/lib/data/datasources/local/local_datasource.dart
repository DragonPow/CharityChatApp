import 'package:chat_app/data/models/message_model.dart';
import 'package:chat_app/data/models/room_model.dart';
import 'package:tuple/tuple.dart';

import '../room_datasource.dart';
import '../chat_datasource.dart';
import 'cache_datasource.dart';

abstract class LocalDataSource implements IChatLocalDataSource, ICacheDataSource, IRoomLocalDataSource{

}

class LocalDatasourceImp implements LocalDataSource {
  @override
  Future<void> cacheMessage(String roomId, List<MessageModel> messages) {
    // TODO: implement cacheMessage
    throw UnimplementedError();
  }

  @override
  Future<void> cacheRooms(List<RoomModel> rooms) {
    // TODO: implement cacheRooms
    throw UnimplementedError();
  }

  @override
  Future<Tuple2<List<RoomModel>, int>> findMessagesByContent(String roomId, String textMatch) {
    // TODO: implement findMessagesByContent
    throw UnimplementedError();
  }

  @override
  Future<List<RoomModel>> findRoomsByName(String textMatch) {
    // TODO: implement findRoomsByName
    throw UnimplementedError();
  }

  @override
  Future<List> getFilesInRoom(String roomId, int startIndex, int number) {
    // TODO: implement getFilesInRoom
    throw UnimplementedError();
  }

  @override
  Future<List> getImagesInRoom(String roomId, int startIndex, int number) {
    // TODO: implement getImagesInRoom
    throw UnimplementedError();
  }

  @override
  Future<List<MessageModel>> getMessagesInRoom(String roomId, int startIndex, int number) {
    // TODO: implement getMessagesInRoom
    throw UnimplementedError();
  }

  @override
  Future<List<RoomModel>> getRoomsByUserId(String userId, int startIndex, int number) {
    // TODO: implement getRoomsByUserId
    throw UnimplementedError();
  }

  @override
  Future<String?> sendFileToRoom(MessageModel message) {
    // TODO: implement sendFileToRoom
    throw UnimplementedError();
  }

  @override
  Future<String?> sendImagesToRoom(List<MessageModel> message) {
    // TODO: implement sendImagesToRoom
    throw UnimplementedError();
  }

  @override
  Future<String?> sendMessageToRoom(MessageModel message) {
    // TODO: implement sendMessageToRoom
    throw UnimplementedError();
  }
}