class ChatId {
  final String chatId;
  final String receiverId;

  ChatId({required this.chatId, required this.receiverId});

  Map<String, dynamic> toMap() {
    return {'chatId': chatId, 'receiverId': receiverId};
  }

  factory ChatId.fromMap(Map<String, dynamic> map) {
    return ChatId(
        chatId: map['chatId'] ?? '', receiverId: map['receiverId'] ?? '');
  }
}
