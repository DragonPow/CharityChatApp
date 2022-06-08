import 'dart:convert';

import 'package:chat_app/dependencies_injection.dart';
import 'package:chat_app/domain/repositories/authenticate_repository.dart';
import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/helper/network/socket_service.dart';
import 'package:chat_app/utils/account.dart';
import 'package:chat_app/utils/local_storage.dart';
import 'package:http/http.dart' as http;

class AuthenticateRepositoryImp extends IAuthenticateRepository {
  final localService = sl<LocalStorageService>();
  final socketService = sl<SocketService>();

  @override
  Future<String?> logIn(String userName, String password) async {
    final queryParams = {
      'username': userName,
      'password': password,
    };
    final uri = Uri.http(serverUrl, '/login', queryParams);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      print('Login success');

      final jsonRes = json.decode(response.body) as Map<String, dynamic>;
      final token = jsonRes['token'] as String;
      final user = jsonRes['user'] as Map<String, dynamic>;
      final newAccount = Account(
          id: user['id'], name: user['name'], imageUri: user['imageUri']);

      // Set to singleton app
      socketService.emitLogin(token);
      Account.setInstanceByCopy(newAccount);
      localService.setAccount(newAccount);
      localService.setToken(token);
      return token;
    } else {
      final jsonRes = json.decode(response.body) as Map<String, dynamic>;
      if (jsonRes['code'] == 'USER_NAME_OR_PASS_WRONG') {
        return null;
      }
      // throw Exception(['Login fail', jsonRes]);
    }
  }

  @override
  Future<void> logOut() async {
    final token = await localService.getToken();
    localService.setToken(null); // Clear token

    final queryParams = {
      'token': token,
    };
    final uri = Uri.http(
      serverUrl,
      '/login',
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      print('Logout success');
    }
  }
}
