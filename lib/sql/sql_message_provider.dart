import 'package:flutter/material.dart';
import 'package:messenger/model/message.dart';
import 'package:sqflite/sqflite.dart';

class SqlMessageProvider extends ChangeNotifier {
  openDb() async {
    Database db = await openDatabase('messages', version: 1,
        onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE  Message(messageId TEXT PRIMARY KEY,senderId TEXT, receiverId TEXT, text TEXT, type TEXT, timeSent TEXT,  isGroup BOOL, chatId TEXT, isSeen BOOL, repliedMessage TEXT, repliedTo TEXT, repliedMessageType TEXT)");
    });
    return db;
  }

  addMessage(
      String messageId,
      String senderId,
      String receiverId,
      String text,
      String type,
      String timeSent,
      bool isGroup,
      String chatId,
      bool isSeen,
      String repliedMessage,
      String repliedTo,
      String repliedMessageType) async {
    Database db = await openDb();
    await db.rawInsert(
        "INSERT INTO Message(messageId,senderId, receiverId, text, type, timeSent,  isGroup, chatId, isSeen, repliedMessage, repliedTo,repliedMessageType) VALUES (?,?,?,?,?,?,?,?,?,?,?,?);",
        [
          messageId,
          senderId,
          receiverId,
          text,
          type,
          timeSent,
          isGroup,
          chatId,
          isSeen,
          repliedMessage,
          repliedTo,
          repliedMessageType
        ]);
    getMessage();
  }

  getMessage() async {
    Database db = await openDb();
    var list = await db.rawQuery("SELECT * FROM Message");
    print(list);
    return list;
  }
}
