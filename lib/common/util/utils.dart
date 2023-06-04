import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/Colors.dart';

void showSnackBar({required BuildContext context, required String content}){

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content), backgroundColor: tabColor,),);

}