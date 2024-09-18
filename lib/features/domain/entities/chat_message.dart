// lib/domain/entities/chat_message.dart
class ChatMessage {
  final String sender; // 'You' or 'Bot'
  final String message;
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.timestamp,
  });
}
