import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/chat.dart';

class ChatModel extends Chat {
  ChatModel({
    required super.chatId,
    required super.chatName,
    super.timestamp,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['chatId'] ?? '',
      chatName: map['chatName'] ?? '',
      timestamp: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'chatName': chatName,
      'createdAt': timestamp,
    };
  }
}
