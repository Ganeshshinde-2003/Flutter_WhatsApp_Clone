import 'dart:io';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/features/auth/screens/login_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_clone/features/select_contacts/screens/select_contact_screen.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_clone/features/status/screens/confirm_status_screen.dart';
import 'package:whatsapp_clone/screens/mobile_layout_screen.dart';
import 'common/widgets/error.dart';

Route<dynamic> generateRoute( RouteSettings settings) {
  switch(settings.name){
    case LoginScreen.routeName:
      return MaterialPageRoute(builder:(context) => const LoginScreen());

    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(builder:(context) => OTPScreen(verificationId: verificationId,));

    case UserInformationScreen.routeName:
      return MaterialPageRoute(builder:(context) => const UserInformationScreen());

    case MobileLayoutScreen.routeName:
      return MaterialPageRoute(builder:(context) => const MobileLayoutScreen());

    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(builder:(context) => MobileChatScreen(name: name,uid: uid,));

    case ConfirmStatusScreen.routeName:
      final file = settings.arguments as File;
      return MaterialPageRoute(builder:(context) => ConfirmStatusScreen(file: file));

    case SelectContactScreen.routeName:
      return MaterialPageRoute(builder:(context) => const SelectContactScreen());

    default:
      return MaterialPageRoute(builder: (context) => const Scaffold(
        body: ErrorScreen(error: "This Page Doesn't Exits",),
      ));
  }
}