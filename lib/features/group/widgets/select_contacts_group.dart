import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:messenger/model/user_model.dart';

class SelectContactsGroup extends StatefulWidget {
  const SelectContactsGroup({super.key});

  @override
  State<SelectContactsGroup> createState() => _SelectContactsGroupState();
}

class _SelectContactsGroupState extends State<SelectContactsGroup> {
  List<int> selectedContactsIndex = [];
  List<UserModel> users = [];
  List<String> members = [];

  getUsers() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final contacts = await FlutterContacts.getContacts(
        withProperties: true, withPhoto: true);
    for (var element in contacts) {
      print(element.phones[0].number);
      await firestore
          .collection("users")
          .where("phoneNumber", isEqualTo: element.phones[0].number)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var user = UserModel.fromMap(docSnapshot.data());
          setState(() {
            users!.add(user);
          });
          var res = user.name;
          print(res);
        }
      });
    }
  }

  getMembers() {
    members.add(FirebaseAuth.instance.currentUser!.uid);
    for (var element in selectedContactsIndex) {
      members.add(users[element].uid);
    }
    return members;
  }

  @override
  void initState() {
    // TODO: implement initState
    getUsers();
    super.initState();
  }

  void selectContact(int index, UserModel contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.removeAt(index);
    } else {
      selectedContactsIndex.add(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (users == []) return CircularProgressIndicator.adaptive();
    return Expanded(
      child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final contact = users[index];
            return InkWell(
              onTap: () => selectContact(index, contact),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  leading: selectedContactsIndex.contains(index)
                      ? IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.done),
                        )
                      : null,
                ),
              ),
            );
          }),
    );
  }
}
