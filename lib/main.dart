import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messenger/common/util/colors.dart';
import 'package:messenger/features/auth/provider/auth_provider.dart';
import 'package:messenger/features/call/provider/call_provider.dart';
import 'package:messenger/features/chat/provider/chat_provider.dart';
import 'package:messenger/features/group/providers/group_provider.dart';
import 'package:messenger/features/landing/screens/splash_screen.dart';
import 'package:messenger/features/selectContacts/provider/contact_provider.dart';
import 'package:messenger/features/status/provider/status_provider.dart';
import 'package:messenger/router.dart';
import 'package:messenger/firebase_options.dart';
import 'package:messenger/sql/sql_message_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => ContactProvider()),
        ChangeNotifierProvider(create: (context) => StatusProvider()),
        ChangeNotifierProvider(create: (context) => GroupProvider()),
        ChangeNotifierProvider(create: (context) => CallProvider()),
        ChangeNotifierProvider(create: (context) => SqlMessageProvider())
      ],
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: const AppBarTheme(
            color: appBarColor,
          ),
        ),
        home: const SplashScreen(),
        onGenerateRoute: (settings) => generateRoute(settings),
      ),
    );
  }
}
