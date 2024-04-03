import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:messenger/features/auth/screens/otp_screen.dart';
import 'package:messenger/features/auth/screens/user_information.screen.dart';
import 'package:messenger/features/chat/provider/chat_provider.dart';
import 'package:messenger/mobile_layout_screen.dart';
import 'package:messenger/model/chat_id.dart';
import 'package:messenger/model/group_id.dart';
import 'package:messenger/model/message.dart';
import 'package:messenger/model/user_model.dart';
import 'package:messenger/sql/sql_message_provider.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var verifyId;
  var phone;

  Future<UserModel?> getCurrentUserData() async {
    var userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .get();
    if (userData.data() != null) {
      UserModel user = UserModel.fromMap(userData.data()!);
      return user;
    }
  }

  signIn(context, phoneNum) async {
    try {
      phone = phoneNum;
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNum,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          print("code sent ${verificationId}");
          verifyId = verificationId;
          Navigator.pushNamed(
            context,
            OtpScreen.routeName,
          );
        }),
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (error) {
      throw (error);
    }
  }

  otpVerification(context, val) async {
    try {
      print(val);
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential =
          PhoneAuthProvider.credential(verificationId: verifyId, smsCode: val);
      // Sign the user in (or link) with the credential
      await auth.signInWithCredential(credential);
      fetchUserBackup();
      Navigator.pushNamedAndRemoveUntil(
          context, UserInformationScreen.routeName, (route) => false);
    } on FirebaseException catch (err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
    }
  }

  fetchUserBackup() async {
    List<Message> chats = [];
    List<Message> chat;
    List<ChatId> chatIds = [];
    UserModel profile;
    List<GroupId> groupIds = [];
    chatIds = await ChatProvider().fetchChatIds();
    groupIds = await ChatProvider().fetchGroupId();

    if (chatIds != []) {
      for (var index in chatIds) {
        print(index.chatId);
        chat = await fetchchat(index.chatId);
        print(chat);
        chats = chats + chat;
        print(chats);
        // chats.add(chat);
      }
    }
    if (groupIds != []) {
      for (var index in groupIds) {
        print(index.chatId);
        chat = await fetchchat(index.chatId);
        print(chat);
        // chats.add(chat);
        chats = chats + chat;
        print(chats);
      }
    }
    print(chats);
    await SqlMessageProvider().getMessage();
  }

  fetchchat(chatId) async {
    List<Message> chat = [];
    var res = await firestore
        .collection("chats")
        .doc('chat')
        .collection("chat")
        .doc(chatId)
        .collection(chatId)
        .get()
        .then((QuerySnapshot) {
      for (var doc in QuerySnapshot.docs) {
        print(doc);
        chat.add(Message.fromMap(doc.data()));
      }
    });
    print(chat);
    // chat = res!;
    return chat;
  }

  sendUserInfo(uid, image, name, context) async {
    try {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("/profile/${uid}")
          .putFile(image!);
      TaskSnapshot snap = await uploadTask;
      String photoUrl = await snap.ref.getDownloadURL();
      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: phone,
          groupId: []);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(user.toMap());
      Navigator.pushNamedAndRemoveUntil(
          context, MobileLayoutScreen.routeName, (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
