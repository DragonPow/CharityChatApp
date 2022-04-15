import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/helper/error/internet_exception.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  String get findRoomURL => roomURL + '/find';
  String get createRoomURL => roomURL + '/c';
  String get deleteRoomURL => roomURL + '/d';
  String get updateRoomURL => roomURL + '/u';

  // String get messageURL => DB_URL + '/message';
  String getMessageURL(String roomId) => DB_URL + '/$roomId';
  String getCreateMessageURL(String roomId) => getMessageURL(roomId) + '/send';

  String get userURL => DB_URL + '/user';

  RemoteDataSourceImp({required this.client});

  @override
  Future<bool> addUserToRoom(String roomId, String userId) async {
    // FIXME: add this method to server
    final res = await client.post(Uri.parse(roomURL), body: {});
    return json.decode(res.body)["success"] as bool;
  }

  @override
  Future<String?> changeAvatarRoom(String roomId, String avatarData) async {
    final updateAvatarRoomURL = updateRoomURL + "/avatar";
    final res = await client.post(Uri.parse(updateAvatarRoomURL), body: {
      "roomId": roomId,
      "avatar": avatarData,
    });
    final avatarId = json.decode(res.body)["avatarId"];
    return avatarId;
  }

  @override
  Future<bool> changeNameRoom(String roomId, String newName) async {
    final res = await client.post(Uri.parse(updateRoomURL), body: {
      "name": newName,
    });
    return json.decode(res.body)["success"] as bool;
  }

  @override
  Future<String?> createMessage(MessageModel message) async {
    final res = await client.post(
        Uri.parse(getCreateMessageURL(message.roomId)),
        body: message.toJson());
    final id = json.decode(res.body)['messageId'];
    return id;
  }

  @override
  Future<String?> createRoom(RoomModel room) async {
    final res =
        await client.post(Uri.parse(createRoomURL), body: room.toJson());
    final newRoom = RoomModel.fromJson(
        json.decode(res.body)["room"] as Map<String, dynamic>);
    return newRoom.id;
  }

  @override
  Future<bool> deleteAllMessageInRoom(String roomId) async {
    throw UnimplementedError();
    // TODO: Delete all message of room
    // final res = await client.delete(Uri.parse(getMessageURL(roomId));
    // final rs = json.decode(res.body)['success'] as bool;
    // return rs;
  }

  @override
  Future<bool> deleteMessage(String messageId) async {
    throw UnimplementedError();

    // TODO: Delete message
    // final res = await client.delete(Uri.parse(messageURL + '/$messageId'));
    // final rs = json.decode(res.body)['success'] as bool;
    // return rs;
  }

  @override
  Future<bool> deleteRoom(String roomId) async {
    final res = await client.post(Uri.parse(deleteRoomURL + "/$roomId"));
    final rs = json.decode(res.body)['success'] as bool;
    return rs;
  }

  @override
  Future<Tuple2<List<RoomModel>, int>> findMessagesByContent(
      String roomId, String textMatch) {
    // TODO: implement findMessagesByContent
    throw UnimplementedError();
  }

  @override
  Future<List<RoomModel>> findRoomsByName(String textMatch) async {
    final res = await client.get(Uri.parse(findRoomURL + '/$textMatch'));
    final roomsJs =
        json.decode(res.body)['rooms'] as List<Map<String, dynamic>>;

    return roomsJs.map(RoomModel.fromJson).toList();
  }

  @override
  Future<List<UserModel>> findUsersByName(String textMatch) {
    // TODO: implement findUsersByName
    throw UnimplementedError();
  }

  @override
  Future<List<UserModel>> getActiveUsers(int startIndex, int number) async {
    final res = await client.get(Uri.parse(userURL + '/$startIndex&$number'));
    final usersJs =
        json.decode(res.body)['users'] as List<Map<String, dynamic>>;
    return usersJs.map(UserModel.fromJson).toList();
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
  Future<List<MessageModel>> getMessagesInRoom(
      String roomId, int startIndex, int number) async {
    final res =
        await client.get(Uri.parse(getMessageURL(roomId) + '/$startIndex&$number'));
    final resJs = json.decode(res.body);

    if (res.statusCode == 200) {
      if (resJs['success']) {
        final messagesJs = resJs['users'] as List<Map<String, dynamic>>;
        return messagesJs.map(MessageModel.fromJson).toList();
      }
      return [];
    }

    throw DatabaseException(
        message: 'Cannot load message from roomId: $roomId',
        statusCode: res.statusCode);
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
