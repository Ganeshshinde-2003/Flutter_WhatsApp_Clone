// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum MessageEnum {
  text,
  image,
  audio,
  video,
  gif,
}

extension MessageEnumExtension on MessageEnum {
  String toShortString() {
    return toString().split('.').last;
  }

  static MessageEnum fromShortString(String value) {
    return MessageEnum.values.firstWhere((e) => e.toShortString() == value);
  }
}

class Message {
  final String senderId;
  final String receiverId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'type': type.toShortString(),
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'repliedMessageType': repliedMessageType.toShortString(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      text: map['text'] as String,
      type:  MessageEnumExtension.fromShortString(map['type'] as String),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      messageId: map['messageId'] as String,
      isSeen: map['isSeen'] as bool,
      repliedMessage: map['repliedMessage'] as String,
      repliedTo: map['repliedTo'] as String,
      repliedMessageType: MessageEnumExtension.fromShortString(map['repliedMessageType'] as String),
    );
  }

}
