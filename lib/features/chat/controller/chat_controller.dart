import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/modules/group.dart';
import '../../../common/provider/message_reply_provider.dart';
import '../../../modules/chat_contact.dart';
import '../../../modules/message.dart';
import '../repository/chat_repository.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Group>> chatGroups() {
    return chatRepository.getChatGroups();
  }

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  Stream<List<Message>> groupChatStream(String groupId) {
    return chatRepository.getGroupChatStream(groupId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String recieverUserId,
      bool isGroupChat,
      ) {
    final messageReply = ref.read(messageReplyProvider);
    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendTextMessage(
              context: context,
              text: text,
              recieverUserId: recieverUserId,
              senderUser: value!,
      messageReply: messageReply,
      isGroupChat: isGroupChat,
            ));
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String recieverUserId,
    MessageEnum messageEnum,
      bool isGroupChat,
      ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendFileMessage(
            context: context,
            file: file,
            recieverUserId: recieverUserId,
            senderUserData: value!,
            ref: ref,
            messageEnum: messageEnum,
          messageReply: messageReply,
          isGroupChat: isGroupChat,
        ));
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendGIFMessage(
    BuildContext context,
    String gifUrl,
    String recieverUserId,
      bool isGroupChat,
      ) {
    final messageReply = ref.read(messageReplyProvider);
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPartfromGif = gifUrl.substring(gifUrlPartIndex);
    String gifUrlPart = 'https://i.giphy.com/media/$gifUrlPartfromGif/200.gif';

    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendGIFMessage(
            context: context,
            gifUrl: gifUrlPart,
            recieverUserId: recieverUserId,
            senderUser: value!,
          messageReply: messageReply,
          isGroupChat: isGroupChat,
        ));
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void setMessageSeen (BuildContext context, String recieverUserId, String messageId){
    chatRepository.setChatMessageSeen(context, recieverUserId, messageId);
  }
}
