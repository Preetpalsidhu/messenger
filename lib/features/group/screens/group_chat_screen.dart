// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:messenger/common/util/colors.dart';
import 'package:messenger/features/chat/widgets/bottom_chat_field.dart';
import 'package:messenger/features/group/providers/group_provider.dart';
import 'package:messenger/model/group_id.dart';
//import 'package:messenger/features/call/provider/call_provider.dart';
//import 'package:messenger/model/call.dart';
import 'package:messenger/features/chat/widgets/chat_list.dart';
import 'package:provider/provider.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupId;
  bool isLoading = true;
  GroupChatScreen({Key? key, required this.groupId}) : super(key: key);
  static const routeName = "/group_chat_screen";

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  // context
  GroupId? group;
  bool isLoading = true;

  getData() async {
    group = await context.read<GroupProvider>().getGroup(widget.groupId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 5), () async {
      await getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator.adaptive()
        : Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: appBarColor,
              title: Text(group!.name),
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () {
                    // ; context.read<CallProvider>().makeCall();
                  },
                  icon: const Icon(Icons.video_call),
                ),
              ],
            ),
            body: isLoading
                ? const CircularProgressIndicator.adaptive()
                : Column(
                    children: [
                      Expanded(
                        child: ChatList(chatId: group!.chatId),
                      ),
                      BottomChatField(
                        receiverId: "",
                        isGroup: true,
                        chatId: widget.groupId,
                      )
                    ],
                  ),
          );
  }
}
