import 'dart:convert';
import 'dart:io';
import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/helper/enum.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../domain/entities/base_user_entity.dart';

Map<String, dynamic> parsedJsonToMap(String response) {
  final parsed = json.decode(response).cast<Map<String, dynamic>>();
  return parsed;
}

String getNameOfFile(File file) {
  return file.path.split('/').last;
}

String getTypeOfFile(File file) {
  final extension = file.path.split('.').last;
  if (['jpg', 'png', 'jpeg', 'gif', 'tiff'].contains(extension)) {
    return 'image';
  }
  return 'file';
}

String parseToServerUri(String uri) {
  return 'http://' + serverUrl + '/' + uri;
}

int getSizeFile(File file) {
  return file.lengthSync();
}

List<types.Message> parsedEntityMessageToMessages(
    List<MessageEntity> messages) {
  return messages.map((message) {
    final author = types.User(
        id: message.creator.id,
        imageUrl: message.creator.avatarUri,
        firstName: message.creator.name);
    final status = message.state == MessageState.sending
        ? types.Status.sending
        : message.state == MessageState.error
            ? types.Status.error
            : types.Status.delivered;
    final isLocal = message.value is File;

    switch (message.type) {
      case MessageChatType.text:
        return types.TextMessage(
          author: author,
          id: message.id,
          type: types.MessageType.text,
          text: message.getName,
          showStatus: true,
          status: status,
        );
      case MessageChatType.file:
        return types.FileMessage(
          author: author,
          id: message.id,
          type: types.MessageType.file,
          size: isLocal ? getSizeFile(message.value) : message.value['size'] ?? 0,
          name: message.getName,
          uri: message.getUri,
          showStatus: true,
          status: status,
        );
      case MessageChatType.image:
        {
          // if (!isLocal) {
          //   final partialImage = types.PartialImage(
          //     size: message.value['size'] ?? 0,
          //     name: message.getName,
          //     uri: message.getUri,
          //   );
          //   return types.ImageMessage.fromPartial(
          //       author: author, id: message.id, partialImage: partialImage);
          // }
          return types.ImageMessage(
            author: author,
            id: message.id,
            type: types.MessageType.image,
            size: isLocal
                ? getSizeFile(message.value)
                : message.value['size'] ?? 0,
            name: message.getName,
            uri: message.getUri,
          );
        }
      default:
        return types.UnsupportedMessage(
          author: author,
          id: message.id,
        );
    }
  }).toList();
}

String parseDatetimeToTime(DateTime date) {
  return (date.hour == 12 ? 12 : date.hour % 12).toString() +
      ":" +
      (date.minute > 9
          ? date.minute.toString()
          : "0" + date.minute.toString()) +
      (date.hour % 12 == 0 || date.hour == 12 ? " am" : " pm");
}

String getListIdFromListUser(List<BaseUserEntity> users) {
  return users.map((e) => e.id).join(',');
}
