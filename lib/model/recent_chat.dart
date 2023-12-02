import 'package:messenger/common/enums/meassage_enums.dart';

class RecentChat {
  final String name;
  final String profilePic;
  final DateTime timeSent;
  final String lastMessage;
  final String uid;
  final bool isGroup;
  final MessageEnum type;
  final String chatId;

  RecentChat(
      {required this.name,
      required this.profilePic,
      required this.timeSent,
      required this.lastMessage,
      required this.uid,
      required this.isGroup,
      required this.type,
      required this.chatId});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
      'uid': uid,
      'isGroup': isGroup,
      'type': type,
      'chatId': chatId
    };
  }

  factory RecentChat.fromMap(Map<String, dynamic> map) {
    return RecentChat(
        name: map['name'] ?? '',
        profilePic: map['profilePic'] ?? '',
        timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
        lastMessage: map['lastMessage'] ?? '',
        uid: map['uid'] ?? '',
        isGroup: map['isGroup'] ?? 'false',
        type: map['type'] ?? '',
        chatId: map['chatId'] ?? '');
  }
}
