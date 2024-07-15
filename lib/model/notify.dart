
class Notify {
  final String type;
  final String chatId;
  final String id;
  final DateTime timeSent;

  Notify(
      {required this.chatId,
      required this.type,
      required this.id,
      required this.timeSent});

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'chatId': chatId,
      'id': id,
      'timeSent': timeSent.millisecondsSinceEpoch
    };
  }

  factory Notify.fromMap(Map<String, dynamic> map) {
    return Notify(
        type: map['type'] ?? '',
        id: map['id'] ?? '',
        timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
        chatId: map['chatId'] ?? '');
  }
}
