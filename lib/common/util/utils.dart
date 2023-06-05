import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/Colors.dart';

void showSnackBar({required BuildContext context, required String content}){

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content), backgroundColor: tabColor,),);

}

Future <File?> pickImageFromGallery (BuildContext context) async {
  File? image;
  try{
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedImage != Null){
      image = File(pickedImage!.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}