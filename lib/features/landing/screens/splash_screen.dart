import 'package:flutter/material.dart';
import 'package:messenger/common/util/colors.dart';
import 'package:messenger/features/auth/provider/auth_provider.dart';
import 'package:messenger/features/auth/screens/login_screen.dart';
import 'package:messenger/features/chat/provider/chat_provider.dart';
import 'package:messenger/mobile_layout_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () async {
      var user = null;
      user = await context.read<AuthProvider>().getCurrentUserData();
      if (user == null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
      } else {
        context.read<ChatProvider>().getNotifications();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MobileLayoutScreen()));
      }
    });
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 50),
          const Text(
            'Welcome to WhatsApp',
            style: TextStyle(
              fontSize: 33,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: size.height / 12),
          Image.asset(
            'assets/bg.png',
            height: 340,
            width: 340,
            color: tabColor,
          ),
          SizedBox(height: size.height / 12),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'from',
              style: TextStyle(color: greyColor),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "FACEBOOK",
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )
        ]),
      ),
    );
  }
}
