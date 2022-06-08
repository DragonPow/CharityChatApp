
import 'dart:async';
import 'dart:io';

import 'package:chat_app/domain/entities/room_entity.dart';
import 'package:tuple/tuple.dart';

import '../entities/message_entity.dart';

abstract class IChatRepository {
  Future<List<MessageEntity>> getMessages(
      String roomId, int startIndex, int number);
  Future<List> getImages(String roomId, int startIndex, int number);
  Future<List> getFiles(String roomId, int startIndex, int number);

  Future<Map<String,dynamic>> sendMessage(String? content, String roomId, File? files);
  StreamController<List<MessageEntity>> getStreamNewMessage();

  Future<Tuple2<List<MessageEntity>, int>> findMessagesByContent(
      String roomId, String textMatch);

  Future<bool> create(MessageEntity message);
  Future<bool> delete(String messageId);
  Future<bool> deleteAll(String roomId);
}
