import 'package:flutter/material.dart';
import 'package:messenger/features/auth/screens/login_screen.dart';
import 'package:messenger/features/auth/screens/otp_screen.dart';
import 'package:messenger/features/auth/screens/user_information.screen.dart';
import 'package:messenger/features/chat/screens/mobile_chat_screen.dart';
import 'package:messenger/features/status/screens/confirm_status_screen.dart';
import 'package:messenger/mobile_layout_screen.dart';
import 'package:messenger/features/selectContacts/screens/select_contact_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (_) => const LoginScreen());

    case OtpScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => OtpScreen(
                verificationId: settings.arguments,
              ));

    case UserInformationScreen.routeName:
      return MaterialPageRoute(builder: (_) => const UserInformationScreen());

    case MobileLayoutScreen.routeName:
      return MaterialPageRoute(builder: (_) => const MobileLayoutScreen());

    case SelectContact.routeName:
      return MaterialPageRoute(builder: (_) => const SelectContact());

    case MobileChatScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => MobileChatScreen(uid: settings.arguments.toString()));

    case ConfirmStatusScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => ConfirmStatusScreen(path: settings.arguments));

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(child: Text('This page doesn\'t exist')),
        ),
      );
  }
}
