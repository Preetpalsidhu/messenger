class GroupId {
  final String chatId;
  final String adminId;
  final String name;
  final String groupPic;
  final List<String> members;

  GroupId(
      {required this.name,
      required this.groupPic,
      required this.adminId,
      required this.chatId,
      required this.members});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'groupPic': groupPic,
      'chatId': chatId,
      'adminId': adminId,
      'members': members
    };
  }

  factory GroupId.fromMap(Map<String, dynamic> map) {
    return GroupId(
        chatId: map['chatId'] ?? '',
        adminId: map['adminId'] ?? '',
        name: map['name'] ?? '',
        groupPic: map['groupPic'] ?? '',
        members: List<String>.from(map['members'] ?? ''));
  }
}
