import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/util/utils.dart';
import 'package:whatsapp_clone/info.dart';
import 'package:whatsapp_clone/modules/chat_contact.dart';
import 'package:whatsapp_clone/modules/message.dart';
import 'package:whatsapp_clone/modules/user_module.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth,
  });
  Stream<List<ChatContact>> getChatContacts() {
    return firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').snapshots().asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs){
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore.collection('users').doc(chatContact.contactId).get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(ChatContact(name: user.name, profilePic: user.profilePic, contactId: chatContact.contactId, lastMessage: chatContact.lastMessage, timeSent: chatContact.timeSent,));
      }
      return contacts;
    });
  }
  
  void _saveMessageToMessageSubCollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String userName,
    required String recieverUserName,
    required MessageEnum messageType,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      receiverId: recieverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );
    // Save the message to the sub-collection

    await firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(recieverUserId).collection('messages').doc(messageId).set(message.toMap());
    
    await firestore.collection('users').doc(recieverUserId).collection('chats').doc(auth.currentUser!.uid).collection('messages').doc(messageId).set(message.toMap());

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
    // Save the senderChatContact to the sub-collection
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel recieverUserData;

      var userDataMap = await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);


      var messageId = const Uuid().v1();
      _saveDataToContactSubCollection(senderUser, recieverUserData, text, timeSent, recieverUserId);

      _saveMessageToMessageSubCollection(
        recieverUserId: recieverUserId,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        messageId: messageId,
        recieverUserName: recieverUserData.name,
        userName: senderUser.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
