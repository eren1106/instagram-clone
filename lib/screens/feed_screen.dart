import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/color_provider.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/post_card.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Provider.of<ColorProvider>(context).backgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: Provider.of<ColorProvider>(context).primaryColor,
          height: 32,
        ),
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {
              ColorProvider _colorProvider =
                  Provider.of(context, listen: false);
              _colorProvider.toggleDark();
            },
            icon: Icon(
              Icons.brightness_4_outlined,
              color: Provider.of<ColorProvider>(context).primaryColor,
              //bedtime
              //brightness
            ),
          ),
        ],
      ),
      body: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('posts').where(
                  'uid',
                  whereIn: [...user.following, user.uid]).snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return snapshot.data!.docs.length > 0 ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                ) : Center(child: Text("You haven't followed anyone yet!"),);
              }),
    );
  }
}
