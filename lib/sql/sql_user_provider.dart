import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SqlUserProvider extends ChangeNotifier {
  openDb() async {
    Database db = await openDatabase('contacts', version: 1,
        onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE Contacts(phoneNumber TEXT PRIMARY KEY, name TEXT, chatId TEXT, profilePhoto TEXT)");
    });
    return db;
  }

  addContact(phone, chatId, photo, name) async {
    Database db = openDb();
    await db.rawInsert(
        "INSERT INTO Contacts(phoneNumber, name,chatId, profilePhoto) VALUES (?,?,?,?);",
        [phone, name, chatId, photo]);
  }

  getContacts() async {
    Database db = openDb();
    var list = await db.rawQuery("SELECT * FROM Contacts");
    print(list);
    return list;
  }
}
