import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger/common/util/colors.dart';
import 'package:messenger/features/auth/provider/auth_provider.dart';
import 'package:messenger/features/chat/provider/chat_provider.dart';
import 'package:messenger/features/status/provider/status_provider.dart';
import 'package:messenger/features/status/screens/confirm_status_screen.dart';
import 'package:messenger/features/status/screens/status_screen.dart';
import 'package:messenger/model/status_model.dart';
import 'package:messenger/model/user_model.dart';
import 'package:messenger/sql/models/contact.dart';
import 'package:provider/provider.dart';

class StatusContactsScreen extends StatelessWidget {
  const StatusContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Status>>(
        future: context.watch<StatusProvider>().getStatus(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var statusData = snapshot.data![index];
              // UserModel contactDetail =
              //     context.read<ChatProvider>().userData(statusData.);
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StatusScreen(
                                  status: statusData,
                                )),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          statusData.phoneNumber,
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            statusData.photoUrl[0],
                          ),
                          radius: 30,
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: dividerColor, indent: 85),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          XFile? res =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          File pickedImage = File(res!.path);
          if (pickedImage != null) {
            Navigator.pushNamed(
              context,
              ConfirmStatusScreen.routeName,
              arguments: pickedImage.path,
            );
          }
        },
        backgroundColor: tabColor,
        child: const Icon(
          Icons.image,
          color: Colors.white,
        ),
      ),
    );
  }
}

pickImageFromGallery(BuildContext context) {}
