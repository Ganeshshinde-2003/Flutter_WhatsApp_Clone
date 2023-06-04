import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp_clone/common/util/utils.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';

class AuthRepository {

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.firestore,
    required this.auth,
});

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try{
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber, verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      }, verificationFailed: (e){
        throw Exception(e.message);
      }, codeSent: ((String verificationId, int? resendToken) async {
        Navigator.pushNamed(context, OTPScreen.routeName, arguments: verificationId);
      }), codeAutoRetrievalTimeout: (String verificationID){});
    }
    on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

}