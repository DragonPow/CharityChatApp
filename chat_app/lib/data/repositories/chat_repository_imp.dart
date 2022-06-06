import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/data/datasources/local/local_datasource.dart';
import 'package:chat_app/data/datasources/remote/remote_datasource.dart';
import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/helper/network/network_info.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

import 'package:chat_app/domain/entities/message_entity.dart';

import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImp implements IChatRepository {
  static String messageUrl = serverUrl + "/messages";
  static String messageSelectUrl = ChatRepositoryImp.messageUrl + "/select";
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ChatRepositoryImp({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  }) {
    print('test');
  }

  @override
  Future<bool> create(MessageEntity message) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(String messageId) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteAll(String roomId) {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  Future<Tuple2<List<MessageEntity>, int>> findMessagesByContent(
      String roomId, String textMatch) {
    // TODO: implement findMessagesByContent
    throw UnimplementedError();
  }

  @override
  Future<List> getFiles(String roomId, int startIndex, int number) {
    // TODO: implement getFiles
    throw UnimplementedError();
  }

  @override
  Future<List> getImages(String roomId, int startIndex, int number) {
    // TODO: implement getImages
    throw UnimplementedError();
  }

  @override
  Future<List<MessageEntity>> getMessages(
      String roomId, int startIndex, int number) async {
    final queryParameters = {
      'roomId': roomId,
      'startIndex': startIndex.toString(),
      'number': number.toString(),
      'orderby': 'createTime',
      'orderdirection': 'desc',
      'searchby': 'all',
      'searchvalue': null
    };
    final uri = Uri.http(serverUrl, "/messages/select", queryParameters);
    print(uri);
    final response = await http.get(uri, headers: {'token': 'ADMIN_TOKEN'});
    if (response.statusCode == 200) {
      final jsonRes = json.decode(response.body)['messages'] as List<dynamic>;
      final listMessage =
          jsonRes.map((x) => MessageEntity.fromJson(x)).toList();
      log(response.body);
      return listMessage;
    } else {
      print("Error fetch data");
      throw response;
    }
  }

  @override
  Future<void> sendFile(MessageEntity message) {
    // TODO: implement sendFile
    throw UnimplementedError();
  }

  @override
  Future<void> sendImages(List<MessageEntity> message) {
    // TODO: implement sendImages
    throw UnimplementedError();
  }

  @override
  Future<void> sendMessage(String content, String roomId) async {
    final _uri = Uri.http(serverUrl, "/messages/send/byRoomId");
    var _messageToJson = <String, dynamic>{};
    _messageToJson['content'] = content;
    _messageToJson['roomId'] = roomId;
    try {
      final _response = await http.post(_uri, body: _messageToJson);
      if (_response.statusCode == 200) {
        print("Success send message");
      } else {
        print("Failed send message");
        print(_response);
      }
    } catch (e) {
      print("Error send message: " + e.toString());
    }
  }
}
