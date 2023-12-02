import 'package:flutter/material.dart';
import 'package:messenger/features/auth/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({super.key, required this.verificationId});
  final verificationId;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
  static const routeName = '/otp-screen';
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    verifyOTP(val) async {
      print(val);
      context.read<AuthProvider>().otpVerification(context, val);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Verifying your number'),
      ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text("Please Enter the verification code"),
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: TextField(
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: '- - - - - -',
                hintStyle: TextStyle(
                  fontSize: 30,
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                if (val.length == 6) {
                  verifyOTP(val);
                }
              },
            ),
          )
        ],
      )),
    );
  }
}
