import 'package:flutter/material.dart';
import 'package:messenger/common/util/colors.dart';
import 'package:messenger/features/auth/provider/auth_provider.dart';
import 'package:messenger/features/auth/screens/login_screen.dart';
import 'package:messenger/features/chat/provider/chat_provider.dart';
import 'package:messenger/features/landing/screens/landing_screen.dart';
import 'package:messenger/mobile_layout_screen.dart';
import 'package:messenger/model/user_model.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      UserModel? user;
      user = await context.read<MyAuthProvider>().getCurrentUserData();
      if (user == null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const LandingScreen()));
      } else {
        context.read<ChatProvider>().getNotifications();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const MobileLayoutScreen()));
      }
    });
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: size.height / 3),
                child: Image.asset(
                  'assets/whitelogo.png',
                  height: 100,
                  width: 100,
                  color: Colors.white,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'from',
                        style: TextStyle(color: greyColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      "FACEBOOK",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
