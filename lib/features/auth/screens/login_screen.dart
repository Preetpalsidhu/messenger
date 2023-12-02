import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:messenger/common/util/colors.dart';
import 'package:messenger/common/widgets/custom_button.dart';
import 'package:messenger/features/auth/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login-screen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  Country? selectedCountry;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country country) {
          setState(() {
            print(country);
            selectedCountry = country;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    void sendPhoneNumber() async {
      String phoneNum = phoneController.text.trim();
      phoneNum = '+${selectedCountry!.phoneCode}$phoneNum';
      if (selectedCountry != null && phoneNum.isNotEmpty) {
        try {
          context.read<AuthProvider>().signIn(context, phoneNum);
        } catch (err) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(err.toString())));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Fill out all the Forms")));
      }
    }

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'WhatsApp will need to verify your phone number.',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: pickCountry,
                child: const Text('Pick Country'),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  selectedCountry != null
                      ? Text('+${selectedCountry!.phoneCode}',
                          style: const TextStyle(color: Colors.white))
                      : Container(),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: size.width * 0.7,
                    child: TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        hintText: 'phone number',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.6),
              SizedBox(
                width: 90,
                child: CustomButton(
                  onPressed: sendPhoneNumber,
                  text: 'NEXT',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
