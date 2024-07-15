import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  getContacts() async {
    final contacts = await FlutterContacts.getContacts(
        withProperties: true, withPhoto: true);

    for (var element in contacts) {
      var res = firestore
          .collection("users")
          .where("phoneNume", isEqualTo: element.phones[0].number);
      print(res);
    }
  }
}
