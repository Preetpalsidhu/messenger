import 'package:flutter/material.dart';
import 'package:messenger/colors.dart';
import 'package:messenger/widgets/contacts_list.dart';
import 'package:messenger/widgets/web_chat_appbar.dart';
import 'package:messenger/widgets/web_profile_bar.dart';
import 'package:messenger/widgets/web_search_bar.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  WebProfileBar(),
                  WebSearchBar(),
                  ContactsList(),
                ],
              ),
            ),
          ),
          Column(
            children: [
              const ChatAppBar(),
              Container(
                width: MediaQuery.of(context).size.width * 0.65,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(color: dividerColor),
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/backgroundImage.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
