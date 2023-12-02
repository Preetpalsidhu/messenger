import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:messenger/features/chat/provider/chat_provider.dart';
import 'package:messenger/features/chat/widgets/message_card.dart';
import 'package:messenger/model/message.dart';
import 'package:provider/provider.dart';

class ChatList extends StatefulWidget {
  final chatId;
  const ChatList({Key? key, this.chatId}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  // void onMessageSwipe(
  //   String message,
  //   bool isMe,
  //   MessageEnum messageEnum,
  // ) {
  //   ref.read(messageReplyProvider.state).update(
  //         (state) => MessageReply(
  //           message,
  //           isMe,
  //           messageEnum,
  //         ),
  //       );
  // }

  @override
  Widget build(BuildContext context) {
    print(widget.chatId);
    return StreamBuilder<List<Message>>(
        stream: context.watch<ChatProvider>().getChatStream(widget.chatId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          });

          return ListView.builder(
              controller: messageController,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final messageData = snapshot.data![index];
                // var timeSent = DateFormat.Hm().format(messageData.timeSent);

                return MessageCard(message: messageData);
              });
        });
  }
}
