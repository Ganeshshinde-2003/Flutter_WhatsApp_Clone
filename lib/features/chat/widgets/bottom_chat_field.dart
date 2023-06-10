import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import '../../../Colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  const BottomChatField({
    super.key,
    required this.recieverUserId,
  });

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();

  void sendTextMessage() async {
    if(isShowSendButton){
      ref.read(chatControllerProvider).sendTextMessage(context, _messageController.text.trim(), widget.recieverUserId);
      setState(() {
        _messageController.text = "";
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextFormField(
            controller: _messageController,
            onChanged: (val){
              if(val.isNotEmpty){
                setState(() {
                  isShowSendButton = true;
                });
              }
              else{
                setState(() {
                  isShowSendButton = false;
                });
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: mobileChatBoxColor,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: (){},
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: (){},
                        icon: const Icon(
                          Icons.gif,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: (){},
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: (){},
                      icon: const Icon(
                        Icons.attach_file,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              hintText: 'Type a message!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8,
            right: 2,
            left: 2,
          ),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF128C7E),
            radius: 25,
            child: GestureDetector(
              onTap: sendTextMessage,
              child: Icon(
                isShowSendButton ? Icons.send : Icons.mic,
                color: Colors.white,),
            ),
          ),
        )
      ],
    );
  }
}
