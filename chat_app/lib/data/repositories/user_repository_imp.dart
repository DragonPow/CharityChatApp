import 'dart:convert';

import 'package:chat_app/domain/entities/user_message_entity.dart';
import 'package:chat_app/domain/entities/user_active_entity.dart';
import 'package:chat_app/domain/entities/base_user_entity.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:chat_app/helper/constant.dart';
import 'package:http/http.dart' as http;

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
  Future<List<UserActiveEntity>> getActiveUsers(
      int startIndex, int number) async {
    final _queryPrameters = {
      "startIndex": startIndex.toString(),
      "number": number.toString(),
      "orderby": "name",
      "orderdirection": "desc",
      "searchby": "name",
      "searchvalue": null
    };
    final _uri = Uri.http(serverUrl, "/users/select", _queryPrameters);
    print(_uri);
    try {
      final _response = await http.get(_uri, headers: {"token": 'ADMIN_TOKEN'});
      if (_response.statusCode == 200) {
        final _jsonResponse =
            json.decode(_response.body)["users"] as List<dynamic>;
        List<UserActiveEntity> _listActiveUsers = _jsonResponse
            .map((_userActive) => UserActiveEntity.fromJson(_userActive))
            .toList();
        return _listActiveUsers;
      } else {
        throw _response;
      }
    } catch (e) {
      print("Error load active user: " + e.toString());
      rethrow;
    }
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

  @override
  Future<List<UserActiveEntity>> getUserFriends(
      int starIndex, int number) async {
    final _queryPrameters = {
      "startIndex": starIndex.toString(),
      "number": number.toString(),
      "orderby": "timeCreate",
      "orderdirection": "desc", 
      "searchby": "name",
      "searchvalue": null
    };
    final _uri = Uri.http(serverUrl, "users/friend", _queryPrameters);
    final _response = await http.get(_uri, headers: {"token": "EXAMPLE_TOKEN"});
    if (_response.statusCode == 200) {
      final _resJson = json.decode(_response.body)["users"] as List<dynamic>;
      List<UserActiveEntity> _listfriend =
          _resJson.map((friend) => UserActiveEntity.fromJson(friend)).toList();
      return _listfriend;
    } else {
      throw _response;
    }
  }
}
