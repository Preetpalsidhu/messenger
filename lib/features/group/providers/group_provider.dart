import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:messenger/model/group_id.dart';
import 'package:uuid/uuid.dart';

class GroupProvider extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  getGroup(String id) async {
    var res = await firestore
        .collection("chats")
        .doc("groupId")
        .collection("groupId")
        .doc(id)
        .get();
    GroupId group = GroupId.fromMap(res.data()!);
    print(group.name);
    return group;
  }

  Future<String> createGroup(String name, image, List<String> members) async {
    String id = const Uuid().v4();

    UploadTask uploadTask =
        FirebaseStorage.instance.ref().child("/profile/$id").putFile(image!);
    TaskSnapshot snap = await uploadTask;
    String pic = await snap.ref.getDownloadURL();

    GroupId groupIdMap = GroupId(
        adminId: auth.currentUser!.uid,
        chatId: id,
        members: members,
        groupPic: pic,
        name: name);
    await firestore
        .collection("chats")
        .doc('groupId')
        .collection("groupId")
        .doc(id)
        .set(groupIdMap.toMap());
    print(id);
    return id;
  }
}
