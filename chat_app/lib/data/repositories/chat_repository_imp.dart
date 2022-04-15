import 'package:chat_app/data/datasources/local/local_datasource.dart';
import 'package:chat_app/data/datasources/remote/remote_datasource.dart';
import 'package:chat_app/helper/network/network_info.dart';
import 'package:tuple/tuple.dart';

import 'package:chat_app/domain/entities/message_entity.dart';

import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImp implements IChatRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ChatRepositoryImp({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

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
      String roomId, int startIndex, int number) {
    // TODO: implement getMessages
    throw UnimplementedError();
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
  Future<void> sendMessage(MessageEntity message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}
