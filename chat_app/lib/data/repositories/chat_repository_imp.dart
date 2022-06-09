import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' as io;

import 'package:chat_app/data/datasources/local/local_datasource.dart';
import 'package:chat_app/data/datasources/remote/remote_datasource.dart';
import 'package:chat_app/dependencies_injection.dart';
import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/helper/network/network_info.dart';
import 'package:chat_app/utils/local_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';
import '../../helper/network/socket_service.dart';

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
  });


  @override
  Future<List<MessageEntity>> findMessagesByContent(
      String roomId, String textMatch, startIndex, number) async {
    return await _getMediaChat(roomId, startIndex, number, 'text', textMatch).then((jsonRes) {
      final listMessage =
          jsonRes.map((x) => MessageEntity.fromJson(x)).toList();
      return listMessage;
    });

  }

  @override
  Future<List> getFiles(String roomId, int startIndex, int number) {
    return _getMediaChat(roomId, startIndex, number, 'file');
  }

  @override
  Future<List> getImages(String roomId, int startIndex, int number) {
    return _getMediaChat(roomId, startIndex, number, 'media');
  }

  Future<List<dynamic>> _getMediaChat(String roomId, int startIndex, int number, String type, [String? searchValue]) async {
    final queryParameters = {
      'roomId': roomId,
      'startIndex': startIndex.toString(),
      'number': number.toString(),
      'orderby': 'createTime',
      'orderdirection': 'desc',
      'searchby': type,
      'searchvalue': searchValue
    };
    String token = await getToken();
    
    final uri = Uri.http(serverUrl, "/messages/select", queryParameters);
    print(uri.path);
    final response = await http.get(uri, headers: {'token': token});
    if (response.statusCode == 200) {
      final jsonRes = json.decode(response.body)['messages'] as List<dynamic>;
      return jsonRes;
    } else {
      print("Load message error");
      log(response.body);
      throw response;
    }
  }

  @override
  StreamController<List<MessageEntity>> getStreamNewMessage() {
    final socket = sl<SocketService>();
    final streamController = StreamController<List<MessageEntity>>();

    addMessageFunction(dynamic data) {
      final messagesJson = (data as List)[0] as List;
      final messages = messagesJson.map((message) {
        return MessageEntity.fromJson(message as Map<String, dynamic>);
      }).toList();
      streamController.sink.add(messages);
    }

    const eventAddMessageName = 'messageSent';

    log('get Stream new message');

    socket.addEventListener(eventAddMessageName, addMessageFunction);
    streamController.onCancel = () {
      log('remove event emit addMessage');
      socket.removeEventListener(eventAddMessageName, addMessageFunction);
    };

    return streamController;
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
    String token = await getToken();

    final uri = Uri.http(serverUrl, "/messages/select", queryParameters);
    print(uri.path);
    final response = await http.get(uri, headers: {'token': token});
    if (response.statusCode == 200) {
      final jsonRes = json.decode(response.body)['messages'] as List<dynamic>;
      final listMessage =
          jsonRes.map((x) => MessageEntity.fromJson(x)).toList();
      return listMessage;
    } else {
      print("Load message error");
      log(response.body);
      throw response;
    }
  }

  Future<String> getToken() async {
    final token = await sl<LocalStorageService>().getToken();
    if (token == null) throw Exception('Token required');
    return token;
  }

  @override
  Future<Map<String, dynamic>> sendMessage(
      String? content, String roomId, io.File? file) async {
    final token = await getToken();
    final _uri = Uri.http(serverUrl, "/messages/send/byRoomId");
    final request = http.MultipartRequest('POST', _uri);
    request.headers.addAll({'token': token});

    request.fields['roomId'] = roomId;
    if (content != null) {
      request.fields['content'] = content;
    } else if (file != null) {
      // Function get multipart file
      getMultipart(io.File file) {
        return http.MultipartFile.fromPath('files', file.path);
      }

      request.files.add(await getMultipart(file));
    } else {
      throw Exception('File or content must contain');
    }

    final responseStream = await request.send();

    if (responseStream.statusCode == 200) {
      final response = await http.Response.fromStream(responseStream);
      return jsonDecode(response.body);
    } else {
      responseStream.stream
          .transform(utf8.decoder)
          .listen((event) => print('Send message error: ' + event));
      throw Exception('Send message fail');
    }
  }
}
