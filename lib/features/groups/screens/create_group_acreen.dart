import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/Colors.dart';
import 'package:whatsapp_clone/common/util/utils.dart';
import 'package:whatsapp_clone/features/groups/widgets/select_contact_groups.dart';

class CreateGroupScreen extends StatefulWidget {
  static const String routeName = '/create-group-screen';
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();
  File? image;

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void createGroup () {
    if(groupNameController.text.trim().isNotEmpty && image != null){

    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    groupNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "http://pluspng.com/img-png/png-user-icon-circled-user-icon-2240.png"),
                  radius: 64,
                )
                    : CircleAvatar(
                  backgroundImage: FileImage(image!),
                  radius: 64,
                ),
                Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo)))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: groupNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter Group Name',
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text("Select Contacts", style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),),
            ),
            const SelectContactGroup(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        backgroundColor: tabColor,
        child: const Icon(Icons.done, color: Colors.white,),
      ),
    );
  }
}
