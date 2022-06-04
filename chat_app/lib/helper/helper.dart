import 'dart:convert';
import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:chat_app/helper/enum.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

Map<String, dynamic> parsedJsonToMap(String response) {
  final parsed = json.decode(response).cast<Map<String, dynamic>>();
  return parsed;
}

List<types.Message> parsedEntityMessageToMessages(
    List<MessageEntity> messages) {
  return messages.map((message) {
    switch (message.type) {
      case MessageChatType.text:
        return types.TextMessage(
            author: types.User(
                id: message.creator.id,
                imageUrl: message.creator.avatarUri,
                firstName: message.creator.name),
            id: message.id,
            type: types.MessageType.text,
            text: message.content);
      case MessageChatType.file:
        return types.FileMessage(
          author: types.User(
              id: message.creator.id,
              imageUrl: message.creator.avatarUri,
              firstName: message.creator.name),
          id: message.id,
          type: types.MessageType.file,
          size: 59645,
          name: "file",
          uri: "",
        );
      case MessageChatType.image:
        return types.ImageMessage(
          author: types.User(
              id: message.creator.id,
              imageUrl: message.creator.avatarUri,
              firstName: message.creator.name),
          id: message.id,
          type: types.MessageType.image,
          size: 59645,
          name: "img",
          uri: "",
        );
      default:
        return types.UnsupportedMessage(
          author: types.User(
              id: message.creator.id,
              imageUrl: message.creator.avatarUri,
              firstName: message.creator.name),
          id: message.id,
        );
    }
  }).toList();
}
