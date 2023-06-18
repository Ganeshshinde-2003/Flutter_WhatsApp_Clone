import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/util/utils.dart';

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  GroupRepository ({
   required this.firestore, required this.auth, required this.ref,
});

  void createGroup (BuildContext context, String name, File profilePic, List<Contact> selectedContact) async {
    try{
      List<String> uids =[];
      for(int i=0; i<selectedContact.length; i++){
        var userCollection = await firestore.collection('users').where('phoneNumber', isEqualTo: selectedContact[i].phones[0].number.replaceAll(" ", "")).get();
        if(userCollection.docs[0].exists){
          uids.add(userCollection.docs[0].data()['uid']);
        }
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

}