import 'dart:convert';
import 'dart:developer';
import 'package:localstore/localstore.dart';
import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/utils/account.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../dependencies_injection.dart';
import '../helper/network/socket_service.dart';

class StorageTypeEnum {
  static get username => 'username';
  static get password => 'password';
  static get token => 'token';
  static get account => 'account';
}

class LocalStorageService {
  final socket = sl<SocketService>();
  final _storage = Localstore.instance.collection('app');

  Future<Map<String, dynamic>?> _getDoc(String docName) async {
    return _storage.doc(docName).get().onError((error,s) => null);
  }

  Future<T?> getItem<T>(String key) async {
    final json = await _getDoc(key);
    return json?[key] as T?;
  }

  Future<void> setItem(String key, dynamic value) {
    return _storage.doc(key).set({key: value});
  }

  Future<Map<String, String?>> getUsernameAndPass() async {
    final json = await _getDoc(StorageTypeEnum.username);
    final username = json?[StorageTypeEnum.username] as String?;
    final password = json?[StorageTypeEnum.password] as String?;

    return {'username': username, 'password': password};
  }

  Future<Account?> getAccount() async {
    final json = await _getDoc(StorageTypeEnum.account);
    final account = json?[StorageTypeEnum.account];
    return account;
  }

  Future<String?> getToken() async {
    final json = await _getDoc(StorageTypeEnum.token);
    final token = json?[StorageTypeEnum.token] as String?;
    return token;
  }

  Future<void> setAccount(Account? account) async {
    await _storage
        .doc(StorageTypeEnum.account)
        .set({StorageTypeEnum.account: account});
    print('Account is set:' + json.encode(account));
    return;
  }

  Future<void> setToken(String? token) async {
    await _storage
        .doc(StorageTypeEnum.token)
        .set({StorageTypeEnum.token: token});
    if (token != null) {
      socket.addEventReconnect((_) => socket.emit('online', token));
    } else {
      socket.removeEventListener('online');
    }
    print('Token is set:' + token.toString());
    return;
  }

  Future<void> setUsernameAndPass(String? username, String? password) async {
    await _storage
        .doc(StorageTypeEnum.username)
        .set({StorageTypeEnum.username: username});
    await _storage
        .doc(StorageTypeEnum.password)
        .set({StorageTypeEnum.password: password});
    print('Username and password is set:' +
        username.toString() +
        ' ' +
        password.toString());
    return;
  }

  // Mock data
  Future<String> getJson(String fileAssets) {
    return rootBundle.loadString(fileAssets);
  }

  Future<Map<String, dynamic>> getMockUserData(int index) async {
    final fileString = await getJson('assets/user.json');
    final data = json.decode(fileString);
    return (data as Map<String, dynamic>)['users'][index];
  }
}
