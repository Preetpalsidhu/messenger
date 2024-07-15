import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/features/call/screens/call_screen.dart';
import 'package:messenger/model/call.dart';

class CallProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('call').doc(auth.currentUser!.uid).snapshots();

  void makeCall(
    Call senderCallData,
    BuildContext context,
    Call receiverCallData,
  ) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firestore
          .collection('call')
          .doc(senderCallData.receiverId)
          .set(receiverCallData.toMap());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
            channelId: senderCallData.callId,
            call: senderCallData,
            isGroupChat: false,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // void makeGroupCall(
  //   Call senderCallData,
  //   BuildContext context,
  //   Call receiverCallData,
  // ) async {
  //   try {
  //     await firestore
  //         .collection('call')
  //         .doc(senderCallData.callerId)
  //         .set(senderCallData.toMap());

  //     var groupSnapshot = await firestore
  //         .collection('groups')
  //         .doc(senderCallData.receiverId)
  //         .get();
  //     model.Group group = model.Group.fromMap(groupSnapshot.data()!);

  //     for (var id in group.membersUid) {
  //       await firestore
  //           .collection('call')
  //           .doc(id)
  //           .set(receiverCallData.toMap());
  //     }

  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => CallScreen(
  //           channelId: senderCallData.callId,
  //           call: senderCallData,
  //           isGroupChat: true,
  //         ),
  //       ),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text(e.toString())));
  //   }
  // }

  void endCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) async {
    try {
      await firestore.collection('call').doc(callerId).delete();
      await firestore.collection('call').doc(receiverId).delete();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // void endGroupCall(
  //   String callerId,
  //   String receiverId,
  //   BuildContext context,
  // ) async {
  //   try {
  //     await firestore.collection('call').doc(callerId).delete();
  //     var groupSnapshot =
  //         await firestore.collection('groups').doc(receiverId).get();
  //     model.Group group = model.Group.fromMap(groupSnapshot.data()!);
  //     for (var id in group.membersUid) {
  //       await firestore.collection('call').doc(id).delete();
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text(e.toString())));
  //   }
}
