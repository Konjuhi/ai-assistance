class Chat {
  final String chatId;
  final String chatName;
  final DateTime? timestamp;

  Chat({
    required this.chatId,
    required this.chatName,
    this.timestamp,
  });
}
