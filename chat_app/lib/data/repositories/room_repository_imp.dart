import 'package:chat_app/domain/entities/room_entity.dart';
import 'package:chat_app/domain/repositories/room_repository.dart';

import '../../helper/network/network_info.dart';
import '../datasources/local/local_datasource.dart';
import '../datasources/remote/remote_datasource.dart';

class RoomRepositoryImp implements IRoomRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RoomRepositoryImp({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<bool> addUser(String roomId, String userId) {
    // TODO: implement addUser
    throw UnimplementedError();
  }

  @override
  Future<bool> changeAvatar(String roomId, String avatarData) {
    // TODO: implement changeAvatar
    throw UnimplementedError();
  }

  @override
  Future<bool> changeName(String roomId, String newName) {
    // TODO: implement changeName
    throw UnimplementedError();
  }

  @override
  Future<bool> create(RoomEntity room) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(String roomId) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<RoomEntity>> findRoomsByName(String textMatch) {
    // TODO: implement findRoomsByName
    throw UnimplementedError();
  }

  @override
  Future<List<RoomEntity>> getRooms(int startIndex, int number) {
    // TODO: implement getRooms
    throw UnimplementedError();
  }

  @override
  Future<bool> removeUser(String roomId, String userId) {
    // TODO: implement removeUser
    throw UnimplementedError();
  }
}
