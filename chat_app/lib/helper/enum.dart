enum MessageChatType {
  text,
  image,
  file,
  system,
}

extension convertString on MessageChatType {
  toShortString() {
    return this.toString().split('.').last;
  } 
}

MessageChatType convertToMessageChatType(String value) {
  return MessageChatType.values.firstWhere(
    (element) => element.toShortString() == value,
    orElse: () => MessageChatType.text,
  );
}
