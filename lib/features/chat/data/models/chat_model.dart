import 'package:ai_assistant/features/chat/domain/entities/chat.dart';

class ChatModel extends Chat {
  ChatModel({
    required super.chatId,
    required super.chatName,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['chatId'],
      chatName: map['chatName'] ?? 'Chat ${map['chatId']}',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'chatName': chatName,
    };
  }
}
