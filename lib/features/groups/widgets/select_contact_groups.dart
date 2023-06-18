import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/Loader.dart';
import 'package:whatsapp_clone/common/widgets/error.dart';
import 'package:whatsapp_clone/features/select_contacts/controller/select_contact_cotroller.dart';

final selectedGroupContact = StateProvider<List<Contact>>((ref) => []);

class SelectContactGroup extends ConsumerStatefulWidget {
  const SelectContactGroup({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectContactGroup> createState() => _SelectContactGroupState();
}

class _SelectContactGroupState extends ConsumerState<SelectContactGroup> {
  List<int>selectedContactsIndex = [];

  void selectContact (int index, Contact contact){
    if(selectedContactsIndex.contains(index)){
      selectedContactsIndex.removeAt(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref.read(selectedGroupContact.state).update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactProvider).when(data: (contactList) =>
        Expanded(
            child: ListView.builder(itemBuilder: (context,index){
              final contact = contactList[index];
              return InkWell(
                onTap: () => selectContact(index, contact),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text(contact.displayName, style: const TextStyle(fontSize: 18,),),
                    leading: selectedContactsIndex.contains(index) ? IconButton(onPressed: (){}, icon: const Icon(Icons.done)) : null,
                  ),
                ),
              );
            },itemCount: contactList.length,),
        ),
        error: (err,trace) => ErrorScreen(error: err.toString()),
        loading: () => const Loader());
  }
}
