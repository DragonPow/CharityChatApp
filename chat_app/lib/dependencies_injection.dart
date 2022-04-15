import 'dart:io';
import 'package:chat_app/presentation/bloc/chat/chat_bloc.dart';
import 'package:chat_app/presentation/bloc/room/room_bloc.dart';
import 'package:chat_app/presentation/bloc/user_active/user_active_cubit.dart';
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
  sl.registerLazySingleton<IO.Socket>(() => IO.io('http://localhost:3000'));
  sl.registerLazySingleton(() => SocketService(socket: sl()));

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

  // Internet checker
  sl.registerSingleton(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInforImp(connectionChecker: sl()));

  // datasource
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImp(client: sl()));
  // sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImp(client: sl()));

  // bloc
  sl.registerFactory(() => ChatBloc(chatRepository: sl()));
  sl.registerFactory(() => RoomBloc(roomRepository: sl()));
  sl.registerFactory(() => UserActiveCubit(userRepository: sl()));
}
