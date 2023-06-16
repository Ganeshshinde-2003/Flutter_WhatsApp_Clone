enum MessageTypeEnum {
  text,
  image,
  audio,
  video,
  gif,
}

extension ConvertMessage on String {
  MessageTypeEnum toEnum() {
    switch (this) {
      case 'audio':
        return MessageTypeEnum.audio;
      case 'image':
        return MessageTypeEnum.image;
      case 'text':
        return MessageTypeEnum.text;
      case 'video':
        return MessageTypeEnum.video; 
      case 'gif':
        return MessageTypeEnum.gif;
      default:
        return MessageTypeEnum.text;
    }
  }
}
