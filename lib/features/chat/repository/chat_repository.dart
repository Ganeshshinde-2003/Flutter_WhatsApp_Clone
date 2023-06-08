import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp_clone/common/util/utils.dart';
import 'package:whatsapp_clone/modules/chat_contact.dart';
import 'package:whatsapp_clone/modules/user_module.dart';

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
});
  void _saveMessageToMessageSubCollection(
  {
    required String recieverUserId, required String text, required DateTime timeSent, required String messageId, required String userName, required recieverUserName,
}
      ) async {

  }

  void _saveDataToContactSubCollection(
      UserModel senderUserData,
      UserModel recieverUserData,
      String text,
      DateTime timeSent,
      String recieverUserId,
      ) async {
      var recieverChatContact = ChatContact(name: senderUserData.name, profilePic: senderUserData.profilePic, contactId: senderUserData.uid, lastMessage: text, timeSent: timeSent);
      await firestore.collection('users').doc(recieverUserId).collection("chats").doc(senderUserData.uid).set(recieverChatContact.toMap());

      var senderChatContact = ChatContact(name: recieverUserData.name, profilePic: recieverUserData.profilePic, contactId: recieverUserData.uid, lastMessage: text, timeSent: timeSent);
      await firestore.collection('users').doc(senderUserData.uid).collection("chats").doc(recieverUserData.uid).set(senderChatContact.toMap());
  }
  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
}) async {
    try{
      var timeSent = DateTime.now();
      UserModel recieverUserData;

      var userDataMap = await firestore.collection('user').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      _saveDataToContactSubCollection(senderUser, recieverUserData, text, timeSent, recieverUserId);

      _saveMessageToMessageSubCollection();

    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}

