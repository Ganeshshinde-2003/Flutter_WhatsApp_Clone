import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
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
    required this.chatRepository, required this.ref,
});

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  void sendTextMessage(BuildContext context, String text, String recieverUserId, ) {
    ref.read(userDataAuthProvider).whenData((value) => chatRepository.sendTextMessage(context: context, text: text, recieverUserId: recieverUserId, senderUser: value!,) );
  }

  void sendFileMessage(BuildContext context, File file, String recieverUserId, MessageEnum messageEnum,){
    ref.read(userDataAuthProvider).whenData((value) => chatRepository.sendFileMessage(context: context, file: file, recieverUserId: recieverUserId, senderUserData: value!, ref: ref, messageEnum: messageEnum));
  }

}















