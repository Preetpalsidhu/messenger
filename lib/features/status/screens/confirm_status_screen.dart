import 'dart:io';

import 'package:flutter/material.dart';
import 'package:messenger/common/util/colors.dart';
import 'package:messenger/features/auth/provider/auth_provider.dart';
import 'package:messenger/features/status/provider/status_provider.dart';
import 'package:provider/provider.dart';

class ConfirmStatusScreen extends StatelessWidget {
  static const String routeName = '/confirm-status-screen';
  final path;
  const ConfirmStatusScreen({super.key, required this.path});
  @override
  Widget build(BuildContext context) {
    File status = File(path);
    var uid = context.read<MyAuthProvider>().auth.currentUser!.uid;
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(File(path)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.done,
            color: Colors.white,
          ),
          onPressed: () => {
                print(uid),
                context
                    .read<StatusProvider>()
                    .uploadStatus(statusImage: status, context: context),
                Navigator.pop(context)
              }),
      backgroundColor: tabColor,
    );
  }
}
