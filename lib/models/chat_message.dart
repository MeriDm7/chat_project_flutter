import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  text,
  image,
  unknown,
}

class ChatMessage {
  final String senderID;
  final MessageType type;
  final String content;
  final DateTime sentTime;

  ChatMessage(
      {required this.content,
      required this.type,
      required this.senderID,
      required this.sentTime});

  factory ChatMessage.fromJSON(Map<String, dynamic> _json) {
    MessageType _messageType;
    switch (_json["type"]) {
      case "text":
        _messageType = MessageType.text;
        break;
      case "image":
        _messageType = MessageType.image;
        break;
      default:
        _messageType = MessageType.unknown;
    }
    return ChatMessage(
      content: _json["content"],
      type: _messageType,
      senderID: _json["sender_id"],
      sentTime: _json["sent_time"].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    String _messageType;
    switch (type) {
      case MessageType.text:
        _messageType = "text";
        break;
      case MessageType.image:
        _messageType = "image";
        break;
      default:
        _messageType = "";
    }
    return {
      "content": content,
      "type": _messageType,
      "sender_id": senderID,
      "sent_time": Timestamp.fromDate(sentTime),
    };
  }
}
