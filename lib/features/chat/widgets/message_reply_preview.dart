import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/provider/message_reply_provider.dart';
import 'package:whatsapp_clone/features/chat/widgets/display_text_image_gif.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    void cancelReply(WidgetRef ref){
      ref.read(messageReplyProvider.state).update((state) => null);
    }
    return Container(
      width: 350,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        )
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: Text(messageReply!.isMe ? "Me" : "Opposite", style: const TextStyle(fontWeight: FontWeight.bold),)),
              GestureDetector(
                child: const Icon(Icons.close, size: 16,),
                onTap: () => cancelReply(ref),
              )
            ],
          ),
          const SizedBox(height: 8,),
          DisplayTextImageGIF(type: messageReply.messageEnum, message: messageReply.message),
        ],
      ),
    );
  }
}
