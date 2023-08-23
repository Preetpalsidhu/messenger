import 'package:flutter/material.dart';
import 'package:messenger/responsive/responsive_layout.dart';
import 'package:messenger/screens/mobile_screen_layout.dart';
import 'package:messenger/screens/web_screen_layout.dart';
import 'package:messenger/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messenger Ui',
      theme:
          ThemeData.dark().copyWith(scaffoldBackgroundColor: backgroundColor),
      home: const Scaffold(
        body: RespnsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout()),
      ),
    );
  }
}
