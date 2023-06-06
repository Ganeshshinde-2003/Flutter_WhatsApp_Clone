import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/Loader.dart';
import 'package:whatsapp_clone/common/widgets/error.dart';
import 'package:whatsapp_clone/features/select_contacts/controller/select_contact_cotroller.dart';

class SelectContactScreen extends ConsumerWidget {
  static const routeName = '/select-contact';
  const SelectContactScreen({Key? key}) : super(key: key);

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Select contact"),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        body: ref.watch(getContactProvider).when(
            data: (contactList) => ListView.builder(
                  itemBuilder: (context, index) {
                    final contact = contactList[index];
                    return InkWell(
                      onTap: () => selectContact(ref, contact, context),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            contact.displayName,
                            style: const TextStyle(fontSize: 18),
                          ),
                          leading: contact.photo == null
                              ? null
                              : CircleAvatar(
                                  backgroundImage: MemoryImage(contact.photo!),
                                  radius: 30,
                                ),
                        ),
                      ),
                    );
                  },
                  itemCount: contactList.length,
                ),
            error: (err, trace) {
              ErrorScreen(error: err.toString());
            },
            loading: () => const Loader()));
  }
}
