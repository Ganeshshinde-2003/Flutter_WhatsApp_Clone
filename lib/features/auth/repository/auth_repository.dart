import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/repository/common_firebase_storage_repository.dart';
import 'package:whatsapp_clone/common/util/utils.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/user_information_screen.dart';
import 'dart:io';

final authRepositoryProvider = Provider((ref) => AuthRepository(firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

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
  
  void verifyOTP({required BuildContext context, required String verificationId, required String userOTP}) async {
    try{
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(context, UserInformationScreen.routeName,(route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void saveUserDataToFirebase({
    required String name, required File? profilePic, required ProviderRef ref, required BuildContext context,
})
  async {
    try{

      String uid = auth.currentUser!.uid;
      String photoUrl = 'http://pluspng.com/img-png/png-user-icon-circled-user-icon-2240.png';

      if(profilePic != null) {
        photoUrl = await ref.read(commonFirebaseStorageRepositoryProvider).storeFileToFirebase('profilePic/$uid', profilePic);
      }



    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

}