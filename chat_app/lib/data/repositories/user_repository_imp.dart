import 'package:chat_app/domain/entities/user_message_entity.dart';
import 'package:chat_app/domain/entities/user_active_entity.dart';
import 'package:chat_app/domain/entities/base_user_entity.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';

import '../../helper/network/network_info.dart';
import '../datasources/local/local_datasource.dart';
import '../datasources/remote/remote_datasource.dart';

class UserRepositoryImp extends IUserRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImp({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<BaseUserEntity>> findUsersByName(String textMatch) {
    // TODO: implement findUsersByName
    throw UnimplementedError();
  }

  @override
  Future<List<UserActiveEntity>> getActiveUsers(int startIndex, int number) {
    // TODO: implement getActiveUsers
    throw UnimplementedError();
  }

  @override
  Future<BaseUserEntity> getUserById(String userId) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<List<UserMessageEntity>> getUsersInRoom(String roomId) {
    // TODO: implement getUsersInRoom
    throw UnimplementedError();
  }
}
