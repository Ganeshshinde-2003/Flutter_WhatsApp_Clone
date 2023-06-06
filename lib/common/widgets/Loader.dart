import 'package:flutter/material.dart';
import 'package:whatsapp_clone/Colors.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: tabColor,
      ),
    );
  }
}
