import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger/common/enums/meassage_enums.dart';
import 'package:messenger/common/util/colors.dart';
import 'package:messenger/features/chat/provider/chat_provider.dart';
import 'package:provider/provider.dart';

class BottomChatField extends StatefulWidget {
  final receiverId;
  final isGroup;
  final chatId;
  const BottomChatField(
      {super.key, this.receiverId, this.isGroup, this.chatId});

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  //FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isShowEmojiContainer = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    //_soundRecorder = FlutterSoundRecorder();
    //openAudio();
  }

  // void openAudio() async {
  //   final status = await Permission.microphone.request();
  //   if (status != PermissionStatus.granted) {
  //     throw RecordingPermissionException('Mic permission not allowed!');
  //   }
  //   await _soundRecorder!.openRecorder();
  //   isRecorderInit = true;
  // }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    // _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    String receiverId = widget.isGroup ? "Group" : widget.receiverId;
    void sendTextMessage() async {
      if (isShowSendButton) {
        context.read<ChatProvider>().sendMessage(
              widget.receiverId,
              widget.isGroup,
              widget.chatId,
              _messageController.text,
              MessageEnum.text,
            );
        setState(() {
          _messageController.text = '';
        });
      }
      // else {
      //   var tempDir = await getTemporaryDirectory();
      //   var path = '${tempDir.path}/flutter_sound.aac';
      //   if (!isRecorderInit) {
      //     return;
      //   }
      //   if (isRecording) {
      //     await _soundRecorder!.stopRecorder();
      //     sendFileMessage(File(path), MessageEnum.audio);
      //   } else {
      //     await _soundRecorder!.startRecorder(
      //       toFile: path,
      //     );
      //   }

      //   setState(() {
      //     isRecording = !isRecording;
      //   });
      // }
    }

    void selectImage() async {
      XFile? res = await ImagePicker().pickImage(source: ImageSource.gallery);
      File image = File(res!.path);
      context
          .read<ChatProvider>()
          .sendImage(image, receiverId, widget.isGroup, widget.chatId);
    }

    void selectVideo() async {
      XFile? res = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (res != null) {
        File video = File(res.path);
        context
            .read<ChatProvider>()
            .sendVideo(video, receiverId, widget.isGroup, widget.chatId);
      }
    }

    void selectGIF() async {
      final gif = await Giphy.getGif(
          context: context, apiKey: "coVQFsROeLIySlbDhRM1z055vanshA3x");
      if (gif != null) {
        print(gif);
        int gifUrlPartIndex = gif.url.lastIndexOf('-') + 1;
        String gifUrlPart = gif.url.substring(gifUrlPartIndex);
        String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
        print(newgifUrl);

        context
            .read<ChatProvider>()
            .sendGif(newgifUrl, receiverId, widget.isGroup, widget.chatId);
      }
    }

    void hideEmojiContainer() {
      setState(() {
        isShowEmojiContainer = false;
      });
    }

    void showEmojiContainer() {
      setState(() {
        isShowEmojiContainer = true;
      });
    }

    void showKeyboard() => focusNode.requestFocus();
    void hideKeyboard() => focusNode.unfocus();

    void toggleEmojiKeyboardContainer() {
      if (isShowEmojiContainer) {
        showKeyboard();
        hideEmojiContainer();
      } else {
        hideKeyboard();
        showEmojiContainer();
      }
    }

    return Column(
      children: [
        //isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: _messageController,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: mobileChatBoxColor,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: toggleEmojiKeyboardContainer,
                              icon: const Icon(
                                Icons.emoji_emotions,
                                color: Colors.grey,
                              ),
                            ),
                            IconButton(
                              onPressed: selectGIF,
                              icon: const Icon(
                                Icons.gif,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    suffixIcon: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: selectImage,
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: selectVideo,
                            icon: const Icon(
                              Icons.attach_file,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    hintText: 'Type a message!',
                    hintStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                    hoverColor: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
                right: 2,
                left: 2,
              ),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF128C7E),
                radius: 25,
                child: GestureDetector(
                  onTap: sendTextMessage,
                  child: Icon(
                    Icons.send,
                    // isShowSendButton
                    //     ? Icons.send
                    //     : isRecording
                    //         ? Icons.close
                    //         : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: ((category, emoji) {
                    setState(() {
                      _messageController.text =
                          _messageController.text + emoji.emoji;
                    });

                    if (!isShowSendButton) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    }
                  }),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
