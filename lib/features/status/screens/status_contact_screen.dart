import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/Loader.dart';
import 'package:whatsapp_clone/features/status/controller/status_controller.dart';
import 'package:whatsapp_clone/features/status/screens/status_screen.dart';
import 'package:whatsapp_clone/modules/status_model.dart';

import '../../../Colors.dart';

class StatusContactScreen extends ConsumerWidget {
  const StatusContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Status>>(
      future: ref.read(statusControllerProvider).getStatus(context),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Loader();
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
            itemBuilder: (context, index){
          var statusData = snapshot.data![index];
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, StatusScreen.routeName, arguments: statusData);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text(
                      statusData.username,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        statusData.profilePic,
                      ),
                      radius: 30,
                    ),
                  ),
                ),
              ),
              const Divider(color: dividerColor, indent: 85),
            ],
          );
        },);
      },
    );
  }
}
