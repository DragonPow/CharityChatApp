import 'dart:io';
import 'package:chat_app/data/datasources/local/local_datasource.dart';
import 'package:chat_app/presentation/bloc/chat_detail/chat_detail_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:chat_app/data/datasources/remote/remote_datasource.dart';

import 'package:chat_app/domain/repositories/chat_repository.dart';
import 'package:chat_app/domain/repositories/room_repository.dart';
import 'package:chat_app/domain/repositories/user_repository.dart';

import 'package:chat_app/helper/network/network_info.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:http/http.dart' as http;
import 'package:chat_app/helper/network/socket_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:chat_app/data/repositories/user_repository_imp.dart';
import 'package:chat_app/data/repositories/chat_repository_imp.dart';
import 'package:chat_app/data/repositories/room_repository_imp.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // socket
  sl.registerSingleton<IO.Socket>(IO.io('http://localhost:3000'));
  sl.registerSingleton(SocketService(socket: sl()));

  // datasource
  sl.registerSingleton(http.Client());
  sl.registerSingleton<LocalDataSource>(LocalDatasourceImp());
  sl.registerSingleton<RemoteDataSource>(RemoteDataSourceImp(client: sl()));

  // Internet checker
  sl.registerSingleton<Connectivity>(Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInforImp(connectionChecker: sl()));

  // repository
  sl.registerLazySingleton<IRoomRepository>(() => RoomRepositoryImp(
        localDataSource: sl(),
        networkInfo: sl(),
        remoteDataSource: sl(),
      ));
  sl.registerLazySingleton<IUserRepository>(() => UserRepositoryImp(
        localDataSource: sl(),
        networkInfo: sl(),
        remoteDataSource: sl(),
      ));
  sl.registerLazySingleton<IChatRepository>(() => ChatRepositoryImp(
        localDataSource: sl(),
        networkInfo: sl(),
        remoteDataSource: sl(),
      ));


  // bloc
}
