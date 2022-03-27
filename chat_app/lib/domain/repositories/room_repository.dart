import '../entities/message_entity.dart';

abstract class IRoomRepository {
  Stream<List<MessageEntity>> getMessages(int roomId, int startIndex, int number);
}