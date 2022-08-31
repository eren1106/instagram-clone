import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/color_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/post_card.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatefulWidget {
  final snap;
  PostScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post',
            style: TextStyle(
                color: Provider.of<ColorProvider>(context).primaryColor)),
        backgroundColor: Provider.of<ColorProvider>(context).backgroundColor,
        elevation: 1,
        iconTheme: IconThemeData(
          color: Provider.of<ColorProvider>(context).primaryColor,
        ),
      ),
      body: PostCard(snap: widget.snap),
    );
  }
}
