import 'package:chat_app/data/models/message_model.dart';
import 'package:chat_app/data/models/room_model.dart';

import '../room_datasource.dart';
import '../chat_datasource.dart';
import 'cache_datasource.dart';

abstract class LocalDataSource implements IChatLocalDataSource, ICacheDataSource, IRoomLocalDataSource{

}