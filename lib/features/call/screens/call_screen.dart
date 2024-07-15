import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:messenger/config/agora.dart';
import 'package:messenger/features/call/provider/call_provider.dart';
import 'package:messenger/model/call.dart';
import 'package:provider/provider.dart';

class CallScreen extends StatefulWidget {
  const CallScreen(
      {super.key,
      required this.channelId,
      required this.call,
      required this.isGroupChat});
  final String channelId;
  final Call call;
  final bool isGroupChat;
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  AgoraClient? client;
  String baseUrl = 'https://whatsapp-clone-rrr.herokuapp.com';

  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: baseUrl,
      ),
    );
    initAgora();
  }

  void initAgora() async {
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: client == null
          ? const CircularProgressIndicator.adaptive()
          : SafeArea(
              child: Stack(
                children: [
                  AgoraVideoViewer(client: client!),
                  AgoraVideoButtons(
                    client: client!,
                    disconnectButtonChild: IconButton(
                      onPressed: () async {
                        await client!.engine.leaveChannel();
                        context.read<CallProvider>().endCall(
                              widget.call.callerId,
                              widget.call.receiverId,
                              context,
                            );
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.call_end),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
