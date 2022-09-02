import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/color_provider.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/post_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/post_card.dart';

class SavedScreen extends StatefulWidget {
  SavedScreen({Key? key}) : super(key: key);

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved'),
        backgroundColor: Provider.of<ColorProvider>(context).backgroundColor,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('posts')
                .where('postId', whereIn: user.saved)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                itemCount: (snapshot.data! as dynamic).docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 1.5,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];

                  return InkWell(
                    onTap: () => Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => PostScreen(snap: snap),
                      ),
                    )
                        .then((value) {
                      setState(() {});
                    }),
                    child: Container(
                      child: Image(
                        image: CachedNetworkImageProvider(
                          (snap.data()! as dynamic)['postUrl'],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
