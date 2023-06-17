import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/repository/common_firebase_storage_repository.dart';
import 'package:whatsapp_clone/common/util/utils.dart';
import 'package:whatsapp_clone/modules/chat_contact.dart';
import 'package:whatsapp_clone/modules/message.dart';
import 'package:whatsapp_clone/modules/user_module.dart';

import '../../../common/provider/message_reply_provider.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth,
  });
  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data() ?? {});
        contacts.add(ChatContact(
          name: user.name,
          profilePic: user.profilePic,
          contactId: chatContact.contactId,
          lastMessage: chatContact.lastMessage,
          timeSent: chatContact.timeSent,
        ));
      }
      return contacts;
    });
  }

  Stream<List<Message>> getChatStream(String recieverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
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
    required MessageReply? messageReply,
    required String senderUsername,
    required String recieverUsername,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      receiverId: recieverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? "" : messageReply.message,
      repliedTo: messageReply == null ? "" : messageReply.isMe ? senderUsername : recieverUsername,
      repliedMessageType: messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );
    // Save the message to the sub-collection

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void _saveDataToContactSubCollection(
    UserModel senderUserData,
    UserModel recieverUserData,
    String text,
    DateTime timeSent,
    String recieverUserId,
  ) async {
    var recieverChatContact = ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        lastMessage: text,
        timeSent: timeSent);
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection("chats")
        .doc(senderUserData.uid)
        .set(recieverChatContact.toMap());

    var senderChatContact = ChatContact(
        name: recieverUserData.name,
        profilePic: recieverUserData.profilePic,
        contactId: recieverUserData.uid,
        lastMessage: text,
        timeSent: timeSent);
    await firestore
        .collection('users')
        .doc(senderUserData.uid)
        .collection("chats")
        .doc(recieverUserData.uid)
        .set(senderChatContact.toMap());
    // Save the senderChatContact to the sub-collection
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel recieverUserData;

      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();
      _saveDataToContactSubCollection(
          senderUser, recieverUserData, text, timeSent, recieverUserId);

      _saveMessageToMessageSubCollection(
        recieverUserId: recieverUserId,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        messageId: messageId,
        recieverUserName: recieverUserData.name,
        userName: senderUser.name,
        messageReply: messageReply,
        recieverUsername: recieverUserData.name,
        senderUsername: senderUser.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage(
      {required BuildContext context,
      required File file,
      required String recieverUserId,
      required UserModel senderUserData,
      required ProviderRef ref,
      required MessageEnum messageEnum,
        required MessageReply? messageReply,
      }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              "chat/${messageEnum.name}/${senderUserData.uid}/$recieverUserId/$messageId",
              file);
      UserModel recieverUserData;
      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = "📸 Photo";
          break;
        case MessageEnum.video:
          contactMsg = "📸 Video";
          break;
        case MessageEnum.audio:
          contactMsg = "🔉 Audio";
          break;
        case MessageEnum.gif:
          contactMsg = "📦 GIF";
          break;
        default:
          contactMsg = "text";
      }

      _saveDataToContactSubCollection(senderUserData, recieverUserData,
          contactMsg, timeSent, recieverUserId);

      _saveMessageToMessageSubCollection(
          recieverUserId: recieverUserId,
          text: imageUrl,
          timeSent: timeSent,
          messageId: messageId,
          userName: senderUserData.name,
          recieverUserName: recieverUserData.name,
          messageType: messageEnum,
        messageReply: messageReply,
        recieverUsername: recieverUserData.name,
        senderUsername: senderUserData.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String recieverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel recieverUserData;

      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();
      _saveDataToContactSubCollection(
          senderUser, recieverUserData, 'GIF', timeSent, recieverUserId);

      _saveMessageToMessageSubCollection(
        recieverUserId: recieverUserId,
        text: gifUrl,
        timeSent: timeSent,
        messageType: MessageEnum.gif,
        messageId: messageId,
        recieverUserName: recieverUserData.name,
        userName: senderUser.name,
        messageReply: messageReply,
        recieverUsername: recieverUserData.name,
        senderUsername: senderUser.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setChatMessageSeen (BuildContext context, String recieverUserId, String messageId) async {
    try{
      await firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(recieverUserId).collection('messages').doc(messageId).update(
        {
          'isSeen':true,
        }
      );

      await firestore.collection('users').doc(recieverUserId).collection('chats').doc(auth.currentUser!.uid).collection('messages').doc(messageId).update(
        {
          'isSeen':true,
        }
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

}
