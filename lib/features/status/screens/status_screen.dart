import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp_clone/common/widgets/Loader.dart';
import '../../../modules/status_model.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = '/status-screen';
  final Status status;
  const StatusScreen({Key? key, required this.status}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  StoryController storyController = StoryController();
  List<StoryItem> storyItems = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initStoryPageItems();
  }

  void initStoryPageItems () {
    for (int i=0; i<widget.status.photoUrl.length; i++){
      storyItems.add(
        StoryItem.pageImage(url: widget.status.photoUrl[i], controller: storyController)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty ? const Loader() : StoryView(
        storyItems: storyItems,
        controller: storyController,
        onVerticalSwipeComplete: (direction){
          if(direction == Direction.down){
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
