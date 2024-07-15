import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:messenger/common/util/colors.dart';
import 'package:messenger/features/chat/screens/mobile_chat_screen.dart';
import 'package:messenger/model/user_model.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({super.key});
  static const String routeName = '/select-contact';

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  List<UserModel>? users = [];
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    // _fetchContacts();
    getUsers();
  }

  // Future _fetchContacts() async {
  //   if (!await FlutterContacts.requestPermission(readonly: true)) {
  //     setState(() => _permissionDenied = true);
  //   } else {
  //     final contacts = await FlutterContacts.getContacts(
  //         withProperties: true, withPhoto: true);
  //     setState(() => _contacts = contacts);
  //   }
  // }

  getUsers() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      for (var element in contacts) {
        if (element.phones.isNotEmpty) {
          if (element.phones[0].number.length > 10) {
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
      }
      // await firestore.collection("groupId").where("members",
      //     arrayContains: FirebaseAuth.instance.currentUser!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              title: const Text('Select contact'),
              backgroundColor: appBarColor,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                  ),
                ),
              ],
            ),
            body: _body()));
  }

  Widget _body() {
    if (_permissionDenied) {
      return const Center(child: Text('Permission denied'));
    }
    if (users == []) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: users!.length,
        itemBuilder: (context, i) => ListTile(
            leading: CircleAvatar(child: Image.network(users![i].profilePic)),
            title: Text(
              users![i].name,
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MobileChatScreen(uid: users![i].uid)),
              );
              // Navigator.pushNamed(context, MobileChatScreen.routeName,
              //     arguments: users![i].uid);
            }));
  }
}
