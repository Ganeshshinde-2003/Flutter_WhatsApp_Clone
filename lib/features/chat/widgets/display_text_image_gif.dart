import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/features/chat/widgets/video_player_item.dart';
import 'package:whatsapp_clone/modules/message.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGIF({Key? key, required this.type, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text? Text(
      message,
      style: const TextStyle(
        fontSize: 16
      ),
    ) : type == MessageEnum.video? VideoPlayerItem(videoURL: message,) : type == MessageEnum.gif ? CachedNetworkImage(imageUrl: message) : CachedNetworkImage(imageUrl: message,);
  }
}
