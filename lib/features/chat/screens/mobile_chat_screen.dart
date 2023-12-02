// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:messenger/common/util/colors.dart';
import 'package:messenger/features/auth/provider/auth_provider.dart';
import 'package:messenger/features/call/provider/call_provider.dart';
import 'package:messenger/features/chat/provider/chat_provider.dart';
import 'package:messenger/features/chat/widgets/bottom_chat_field.dart';
import 'package:messenger/model/call.dart';
//import 'package:messenger/features/call/provider/call_provider.dart';
//import 'package:messenger/model/call.dart';
import 'package:messenger/model/user_model.dart';
import 'package:messenger/features/chat/widgets/chat_list.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MobileChatScreen extends StatefulWidget {
  MobileChatScreen({Key? key, required this.uid}) : super(key: key);
  String uid;
  static const routeName = "/mobile_chat_screen";

  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {
  // context
  bool isLoading = true;
  var user;
  UserModel receiver = UserModel(
      name: "name",
      uid: "uid",
      profilePic: "profilePic",
      isOnline: false,
      phoneNumber: "",
      groupId: []);
  var chatId;

  getData() async {
    user = await context.read<AuthProvider>().getCurrentUserData();
    print(widget.uid);
    receiver = await context.read<ChatProvider>().getProfile(widget.uid);
    print(receiver.uid);
    chatId = await context.read<ChatProvider>().findChatId(receiver.uid);
    setState(() {
      isLoading = false;
    });
    print(receiver.name);
    print(widget.uid);
    print(chatId);
  }

  makeCall() async {
    UserModel? currentUser;
    String callId = const Uuid().v1();
    var res = await context
        .read<AuthProvider>()
        .getCurrentUserData()
        .then((value) => currentUser = value!);
    Call senderCallData = Call(
        callerId: currentUser!.uid,
        callerName: currentUser!.name,
        callerPic: currentUser!.profilePic,
        receiverId: receiver.uid,
        receiverName: receiver.name,
        receiverPic: receiver.profilePic,
        callId: callId,
        hasDialled: true);
    Call receiverCallData = Call(
        callerId: currentUser!.uid,
        callerName: currentUser!.name,
        callerPic: currentUser!.profilePic,
        receiverId: receiver.uid,
        receiverName: receiver.name,
        receiverPic: receiver.profilePic,
        callId: callId,
        hasDialled: false);

    context
        .read<CallProvider>()
        .makeCall(senderCallData, context, receiverCallData);
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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Column(
          children: [
            StreamBuilder<UserModel>(
                stream: context.read<ChatProvider>().userData(widget.uid),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return Column(
                      children: [
                        Text(receiver.name),
                        Text(
                          snapshot.data!.isOnline ? 'online' : 'offline',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ],
                    );
                  }
                }))
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              makeCall();
            },
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: isLoading
          ? const CircularProgressIndicator.adaptive()
          : Column(
              children: [
                Expanded(
                  child: ChatList(chatId: chatId),
                ),
                BottomChatField(
                  receiverId: widget.uid,
                  isGroup: false,
                  chatId: chatId,
                )
              ],
            ),
    );
  }
}
