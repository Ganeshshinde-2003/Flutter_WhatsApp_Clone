import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context, required String content}){

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));

}