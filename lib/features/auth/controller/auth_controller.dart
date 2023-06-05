import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/auth_repository.dart';

final authControllerProvider = Provider((ref){
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({required this.authRepository, required this.ref});

  void signInWithPhone(BuildContext context, String phoneNumber){
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP){
    authRepository.verifyOTP(context: context, verificationId: verificationId, userOTP: userOTP);
  }

  void saveUserDataToFirebase(BuildContext context, String name, File? profilePic){
    authRepository.saveUserDataToFirebase(name: name, profilePic: profilePic, ref: ref, context: context);
  }
}