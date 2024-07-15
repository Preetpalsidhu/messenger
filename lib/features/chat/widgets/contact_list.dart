import 'package:flutter/material.dart';
import 'package:messenger/common/util/colors.dart';
import 'package:messenger/features/chat/provider/chat_provider.dart';
import 'package:messenger/features/chat/screens/mobile_chat_screen.dart';
import 'package:messenger/features/group/screens/group_chat_screen.dart';
import 'package:messenger/features/selectContacts/screens/select_contact_screen.dart';
import 'package:messenger/model/recent_chat.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({super.key});

  @override
  State<ContactsList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactsList> {
  List<RecentChat> data = [];
  getData() async {
    var res = await context.read<ChatProvider>().fetchLastChatData();
    setState(() {
      data = [];
      data = res;
      print(data);
    });
    context.read<ChatProvider>().getNotifications();
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 5), () async {
      await getData();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var outputFormat = DateFormat('MM/dd/yy hh:mm a');
    return Scaffold(
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return ListTile(
                onTap: () {
                  if (data[index].isGroup) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              GroupChatScreen(groupId: data[index].chatId)),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MobileChatScreen(uid: data[index].uid)),
                    );
                  }
                },
                leading: CircleAvatar(
                  child: Image.network(data[index].profilePic),
                ),
                title: Text(data[index].name),
                subtitle: Text(data[index].lastMessage,
                    overflow: TextOverflow.ellipsis),
                trailing: Text(outputFormat.format(data[index].timeSent)));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, SelectContact.routeName);
        },
        backgroundColor: tabColor,
        child: const Icon(
          Icons.comment,
          color: Colors.white,
        ),
      ),
    );
  }
}
