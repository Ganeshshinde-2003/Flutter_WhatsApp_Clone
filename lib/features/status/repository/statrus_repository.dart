import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/repository/common_firebase_storage_repository.dart';
import 'package:whatsapp_clone/common/util/utils.dart';
import 'package:whatsapp_clone/modules/user_module.dart';
import '../../../modules/status_model.dart';

final statusRepositoryProvider = Provider((ref) => StatusRepository(auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance, ref: ref));

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  StatusRepository({required this.auth, required this.firestore, required this.ref});

  void uploadStatus ({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
}) async {
    try{
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageUrl = await ref.read(commonFirebaseStorageRepositoryProvider).storeFileToFirebase("/status/$statusId$uid", statusImage);
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()){
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      List<String> uidWhoCanSee = [];

      for (int i=0; i<contacts.length; i++){
        var userDataFirebase = await firestore.collection('users').where('phoneNumber', isEqualTo: contacts[i].phones[0].number.replaceAll(" ", "")).get();
        if (userDataFirebase.docs.isNotEmpty){
          var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
          uidWhoCanSee.add(userData.uid);
        }
      }
      List<String> statusImageUrls = [];
      var statusSnapShot = await firestore.collection('status').where('uid', isEqualTo:auth.currentUser!.uid).get();

      if(statusSnapShot.docs.isNotEmpty){
        Status status = Status.fromMap(statusSnapShot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageUrl);
        await firestore.collection('status').doc(statusSnapShot.docs[0].id).update(
            {
              'photoUrl': statusImageUrls,
            });
        return;
      }else {
        statusImageUrls = [imageUrl];
      }

      Status status = Status(uid: uid, username: username, phoneNumber: phoneNumber, photoUrl: statusImageUrls, createdAt: DateTime.now(), profilePic: profilePic, statusId: statusId, whoCanSee: uidWhoCanSee);
      await firestore.collection('status').doc(statusId).set(status.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<List<Status>> getStatue( BuildContext context ) async {
    List<Status> statusData = [];
    try{
      List<Contact> contacts = [];
      if(await FlutterContacts.requestPermission()){
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      for (int i=0; i<contacts.length; i++){
        var statusSnapshot = await firestore.collection('status').where('phoneNumber', isEqualTo: contacts[i].phones[0].number.replaceAll(" ", "")).where('createdAt', isGreaterThan: DateTime.now().subtract(const Duration(hours: 24)).millisecondsSinceEpoch,).get();
        for(var tempData in statusSnapshot.docs){
          Status tempStatus = Status.fromMap(tempData.data());
          if(tempStatus.whoCanSee.contains(auth.currentUser!.uid)){
            statusData.add(tempStatus);
          }
        }
      }
    } catch (e){
      if(kDebugMode) print(e);
      showSnackBar(context: context, content: e.toString());
    }
    return statusData;
  }

}