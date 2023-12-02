import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/common/util/colors.dart';
import 'package:messenger/features/auth/provider/auth_provider.dart';
import 'package:messenger/features/chat/widgets/display_message.dart';
import 'package:messenger/model/message.dart';
import 'package:provider/provider.dart';

class MessageCard extends StatelessWidget {
  final Message message;

  const MessageCard({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String user = FirebaseAuth.instance.currentUser!.uid;
    context.read<AuthProvider>().getCurrentUserData();
    return Align(
      alignment: message.senderId == user
          ? Alignment.centerRight
          : message.senderId == 'System'
              ? Alignment.center
              : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: message.senderId == user ? senderMessageColor : messageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 30,
                    top: 5,
                    bottom: 20,
                  ),
                  child: DisplayMessage(
                      message: message.text, type: message.type)),
              Positioned(
                bottom: 4,
                right: 10,
                child: message.senderId == 'System'
                    ? Container()
                    : Row(
                        children: [
                          Text(
                            message.timeSent.toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white60,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.done_all,
                            size: 20,
                            color: Colors.white60,
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
