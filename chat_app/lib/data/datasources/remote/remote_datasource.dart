import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/helper/error/internet_exception.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;

import '../../models/user_model.dart';
import '../../models/room_model.dart';
import '../../models/message_model.dart';

import '../user_datasource.dart';
import '../chat_datasource.dart';
import '../room_datasource.dart';

abstract class RemoteDataSource
    implements
        IChatRemoteDataSource,
        IRoomRemoteDataSource,
        IUserRemoteDataSource {}

class RemoteDataSourceImp implements RemoteDataSource {
  final http.Client client;

  String get roomURL => DB_URL + '/room';
  String get createRoomURL => roomURL + '/c';
  String get deleteRoomURL => roomURL + '/d';
  String get updateRoomURL => roomURL + '/u';

  String get messageURL => DB_URL + '/message';
  String get createMessageURL => messageURL + '/c';
  String get deleteMessageURL => messageURL + '/d';
  String get updateMessageURL => messageURL + '/u';

  RemoteDataSourceImp({required this.client});

  @override
  Future<bool> addUserToRoom(String roomId, String userId) async {
    // FIXME: add this method to server
    final res = await client.post(Uri.parse(roomURL), body: {
      
    });
    return res.headers["success"] as bool;
  }

  @override
  Future<String?> changeAvatarRoom(String roomId, String avatarData) async {
    final updateAvatarRoomURL = updateRoomURL + "/avatar";
    final res = await client.post(Uri.parse(updateAvatarRoomURL), body: {
      "roomId": roomId,
      "avatar": avatarData,
    });
    final avatarId = res.headers["avatarId"];
    return avatarId;
  }

  @override
  Future<bool> changeNameRoom(String roomId, String newName) async {
    final res = await client.post(Uri.parse(updateRoomURL), body: {
      "name": newName,
    });
    return res.headers["success"] as bool;
  }

  @override
  Future<String?> createMessage(MessageModel message) {
    // TODO: implement createMessage
    throw UnimplementedError();
  }

  @override
  Future<String?> createRoom(RoomModel room) async {
    final res = await client.post(Uri.parse(createRoomURL), body: room.toJson());
    final newRoom =  RoomModel.fromJson(res.headers["room"] as Map<String, dynamic>);
    return newRoom.id;
  }

  @override
  Future<bool> deleteAllMessageInRoom(String roomId) {
    // TODO: implement deleteAllMessageInRoom
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteMessage(String messageId) {
    // TODO: implement deleteMessage
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteRoom(String roomId) {
    // TODO: implement deleteRoom
    throw UnimplementedError();
  }

  @override
  Future<Tuple2<List<RoomModel>, int>> findMessagesByContent(
      String roomId, String textMatch) {
    // TODO: implement findMessagesByContent
    throw UnimplementedError();
  }

  @override
  Future<List<RoomModel>> findRoomsByName(String textMatch) {
    // TODO: implement findRoomsByName
    throw UnimplementedError();
  }

  @override
  Future<List<UserModel>> findUsersByName(String textMatch) {
    // TODO: implement findUsersByName
    throw UnimplementedError();
  }

  @override
  Future<List<UserModel>> getActiveUsers(int startIndex, int number) {
    // TODO: implement getActiveUsers
    throw UnimplementedError();
  }

  @override
  Future<List> getFilesInRoom(int roomId, int startIndex, int number) {
    // TODO: implement getFilesInRoom
    throw UnimplementedError();
  }

  @override
  Future<List> getImagesInRoom(int roomId, int startIndex, int number) {
    // TODO: implement getImagesInRoom
    throw UnimplementedError();
  }

  @override
  Future<List<MessageModel>> getMessagesInRoom(
      int roomId, int startIndex, int number) {
    // TODO: implement getMessagesInRoom
    throw UnimplementedError();
  }

  @override
  Future<List<RoomModel>> getRoomsByName(int startIndex, int number) {
    // TODO: implement getRoomsByName
    throw UnimplementedError();
  }

  @override
  Future<UserModel> getUserById(String userId) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<List<UserModel>> getUsersInRoom(String roomId) {
    // TODO: implement getUsersInRoom
    throw UnimplementedError();
  }

  @override
  Future<String?> logIn(String userName, String password) {
    // TODO: implement logIn
    throw UnimplementedError();
  }

  @override
  Future<bool> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<bool> removeUserFromRoom(String roomId, String userId) {
    // TODO: implement removeUserFromRoom
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
