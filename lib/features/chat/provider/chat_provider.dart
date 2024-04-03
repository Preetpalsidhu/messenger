import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:messenger/common/enums/meassage_enums.dart';
import 'package:messenger/model/chat_id.dart';
import 'package:messenger/model/group_id.dart';
import 'package:messenger/model/message.dart';
import 'package:messenger/model/notify.dart';
import 'package:messenger/model/recent_chat.dart';
import 'package:messenger/model/user_model.dart';
import 'package:messenger/sql/sql_message_provider.dart';
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  saveMessage(String chatId, String messageId) async {
    var msg = await firestore
        .collection('chats')
        .doc('chat')
        .collection('chat')
        .doc(chatId)
        .collection(chatId)
        .doc(messageId)
        .get()
        .then((value) => Message.fromMap(value.data()!));
    print(msg.text);
    SqlMessageProvider().addMessage(
        messageId,
        msg.senderId,
        msg.receiverId,
        msg.text,
        msg.type.toText(),
        msg.timeSent.toString(),
        msg.isGroup,
        chatId,
        msg.isSeen,
        msg.repliedMessage,
        msg.repliedTo,
        msg.repliedMessageType.toText());
  }

  getNotifications() async {
    List<Notify> notification = [];
    var res = await firestore
        .collection("notification")
        .doc(auth.currentUser!.uid)
        .collection(auth.currentUser!.uid)
        //    .where("timeSent", isGreaterThanOrEqualTo: 1701177400244)
        .snapshots()
        .listen((event) async {
      for (var change in event.docChanges) {
        if (change.type == DocumentChangeType.added) {
          Notify res = Notify.fromMap(change.doc.data()!);
          print(res.id);
          // notification.add(Notify.fromMap(change.doc.data()!));
          await saveMessage(res.chatId, res.id);
          await firestore
              .collection('notification')
              .doc(auth.currentUser!.uid)
              .collection(auth.currentUser!.uid)
              .doc(res.id)
              .delete();
        }
      }
      print(notification);
    });
  }

  Future<String> findChatId(receiverId) async {
    var res = '';
    await firestore
        .collection("chats")
        .doc("chatId")
        .collection("chatId")
        .doc(auth.currentUser!.uid)
        .collection(auth.currentUser!.uid)
        .where("receiverId", isEqualTo: receiverId)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var chatId = ChatId.fromMap(docSnapshot.data());
          res = chatId.chatId;
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    print(res);
    if (res == '') {
      var id = Uuid().v1();
      ChatId chatId = ChatId(chatId: id, receiverId: receiverId);
      await firestore
          .collection("chats")
          .doc("chatId")
          .collection("chatId")
          .doc(auth.currentUser!.uid)
          .collection(auth.currentUser!.uid)
          .doc()
          .set(chatId.toMap());
      res = id;
      chatId = await ChatId(
          chatId: id, receiverId: FirebaseAuth.instance.currentUser!.uid);
      await firestore
          .collection("chats")
          .doc("chatId")
          .collection("chatId")
          .doc(receiverId)
          .collection(receiverId)
          .doc()
          .set(chatId.toMap());
    }
    return res;
  }

  Future<UserModel> getProfile(id) async {
    var res = await firestore.collection("users").doc(id).get();
    UserModel user = UserModel.fromMap(res.data()!);
    print(user.name);
    return user;
  }

  Stream<List<Message>> getChatStream(String chatId) {
    return firestore
        .collection("chats")
        .doc('chat')
        .collection('chat')
        .doc(chatId)
        .collection(chatId)
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  Future<List<ChatId>> fetchChatIds() async {
    List<ChatId> res = [];
    var data = await firestore
        .collection("chats")
        .doc('chatId')
        .collection('chatId')
        .doc(auth.currentUser!.uid)
        .collection(auth.currentUser!.uid)
        .get()
        .then((QuerySnapshot) {
      for (var docSnapshot in QuerySnapshot.docs) {
        res.add(ChatId.fromMap(docSnapshot.data()));
      }
    });
    print(auth.currentUser!.uid);
    return res;
  }

  fetchGroupId() async {
    List<GroupId> res = [];
    var data = await firestore
        .collection("chats")
        .doc('groupId')
        .collection('groupId')
        .where("members", arrayContains: auth.currentUser!.uid)
        .get()
        .then((QuerySnapshot) {
      for (var docSnapshot in QuerySnapshot.docs) {
        res.add(GroupId.fromMap(docSnapshot.data()));
      }
    });
    return res;
  }

  fetchLastMsg(chatid) async {
    print(chatid);
    Message msg;
    var res = await firestore
        .collection("chats")
        .doc('chat')
        .collection("chat")
        .doc(chatid)
        .collection(chatid)
        .orderBy("timeSent", descending: true)
        .limit(1)
        .get()
        .then((QuerySnapshot) {
      for (var doc in QuerySnapshot.docs) {
        print(doc);
        return Message.fromMap(doc.data());
      }
    });
    print(res);
    msg = res!;
    return msg;
  }

  fetchLastChatData() async {
    List<RecentChat> chats = [];
    Message msg;
    List<ChatId> chatIds = [];
    UserModel profile;
    List<GroupId> groupIds = [];
    chatIds = await fetchChatIds();
    groupIds = await fetchGroupId();

    if (chatIds != []) {
      for (var index in chatIds) {
        print(index.chatId);
        msg = await fetchLastMsg(index.chatId);
        print(msg.senderId);
        profile = await getProfile(index.receiverId);
        print(profile.uid);
        RecentChat chat = RecentChat(
            name: profile.name,
            profilePic: profile.profilePic,
            timeSent: msg.timeSent,
            lastMessage: msg.text,
            uid: profile.uid,
            isGroup: msg.isGroup,
            type: msg.type,
            chatId: index.chatId);
        chats.add(chat);
      }
    }
    if (groupIds != []) {
      for (var index in groupIds) {
        print(index.chatId);
        msg = await fetchLastMsg(index.chatId);
        print(msg.senderId);

        RecentChat chat = RecentChat(
            name: index.name,
            profilePic: index.groupPic,
            timeSent: msg.timeSent,
            lastMessage: msg.text,
            uid: "",
            isGroup: msg.isGroup,
            type: msg.type,
            chatId: index.chatId);
        chats.add(chat);
      }
    }
    print(chats);
    await SqlMessageProvider().getMessage();
    return chats;
  }

  sendSystemMessage(receiverId, groupId, text, MessageEnum type) async {
    var timeSent = DateTime.now();
    print(receiverId);

    var messageId = const Uuid().v1();
    Message message = Message(
        senderId: "System",
        receiverId: receiverId,
        text: text,
        type: type,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false,
        repliedMessage: '',
        repliedTo: '',
        repliedMessageType: MessageEnum.text,
        isGroup: true,
        chatId: groupId);
    firestore
        .collection('chats')
        .doc('chat')
        .collection('chat')
        .doc(groupId)
        .collection(groupId)
        .doc(messageId)
        .set(message.toMap());
    //fetchMessages(chatId);
  }

  findGroupId() {}

  sendMessage(receiverId, isGroup, chatId, text, MessageEnum type) async {
    var timeSent = DateTime.now();
    if (chatId == '') {
      chatId = const Uuid().v4();
      ChatId chatIdMap = ChatId(chatId: chatId, receiverId: receiverId);
      ChatId chatIdMapR = ChatId(
        chatId: chatId,
        receiverId: auth.currentUser!.uid,
      );
      firestore
          .collection("chats")
          .doc('chatId')
          .collection("chatId")
          .doc(auth.currentUser!.uid)
          .collection(auth.currentUser!.uid)
          .doc(chatId)
          .set(chatIdMap.toMap());

      firestore
          .collection("chats")
          .doc('chatId')
          .collection("chatId")
          .doc(receiverId)
          .collection(receiverId)
          .doc(chatId)
          .set(chatIdMapR.toMap());
    }
    var messageId = const Uuid().v1();
    Message message = Message(
        senderId: auth.currentUser!.uid,
        receiverId: receiverId,
        text: text,
        type: type,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false,
        repliedMessage: '',
        repliedTo: '',
        repliedMessageType: MessageEnum.text,
        isGroup: isGroup,
        chatId: chatId);
    print(chatId);
    await firestore
        .collection('chats')
        .doc('chat')
        .collection('chat')
        .doc(chatId)
        .collection(chatId)
        .doc(messageId)
        .set(message.toMap());

    Notify notification = Notify(
        type: "message", id: messageId, timeSent: timeSent, chatId: chatId);
    await firestore
        .collection('notification')
        .doc(receiverId)
        .collection(receiverId)
        .doc(messageId)
        .set(notification.toMap());
    //fetchMessages(chatId);
  }

  sendGif(gifUrl, receiverId, isGroup, GroupId) async {
    String id = const Uuid().v1();
    try {
      sendMessage(receiverId, isGroup, GroupId, gifUrl, MessageEnum.gif);
    } catch (e) {
      throw (e);
    }
  }

  sendImage(image, receiverId, isGroup, GroupId) async {
    String id = const Uuid().v1();
    try {
      UploadTask uploadTask =
          FirebaseStorage.instance.ref().child("/images/$id").putFile(image!);
      TaskSnapshot snap = await uploadTask;
      String imageUrl = await snap.ref.getDownloadURL();
      sendMessage(receiverId, isGroup, GroupId, imageUrl, MessageEnum.image);
    } catch (e) {
      throw (e);
    }
  }

  sendVideo(video, receiverId, isGroup, GroupId) async {
    String id = const Uuid().v1();
    try {
      UploadTask uploadTask =
          FirebaseStorage.instance.ref().child("/images/$id").putFile(video!);
      TaskSnapshot snap = await uploadTask;
      String videoUrl = await snap.ref.getDownloadURL();
      sendMessage(receiverId, isGroup, GroupId, videoUrl, MessageEnum.video);
    } catch (e) {
      throw (e);
    }
  }
}
