import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger/common/enums/meassage_enums.dart';
import 'package:messenger/common/util/colors.dart';
import 'package:messenger/features/chat/provider/chat_provider.dart';
import 'package:messenger/features/group/providers/group_provider.dart';
import 'package:messenger/model/user_model.dart';
import 'package:provider/provider.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();
  File? image;
  void selectImage() async {
    var res = await ImagePicker().pickImage(source: ImageSource.gallery);
    image = File(res!.path);
    setState(() {});
  }

  void createGroup() async {
    if (groupNameController.text.trim().isNotEmpty && image != null) {
      var members = getMembers();
      String groupId = '';
      await context
          .read<GroupProvider>()
          .createGroup(groupNameController.text, image, members)
          .then((value) {
        print(value);
        groupId = value;
      });
      print(groupId);
      for (var element in members) {
        context.read<ChatProvider>().sendSystemMessage(
            element, groupId, "You are Added", MessageEnum.text);
      }
      Navigator.pop(context);
    }
  }

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
            users.add(user);
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
    print(members);
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
      setState(() {
        selectedContactsIndex.add(index);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                        ),
                        radius: 64,
                      )
                    : CircleAvatar(
                        backgroundImage: FileImage(
                          image!,
                        ),
                        radius: 64,
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: groupNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter Group Name',
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Select Contacts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (users == [])
              const CircularProgressIndicator.adaptive()
            else
              Expanded(
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
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createGroup(),
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
