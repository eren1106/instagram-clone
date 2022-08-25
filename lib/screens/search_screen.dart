import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/post_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';

import '../providers/color_provider.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  bool isLoading = false;
  var users = []; // variable to store all users data
  var currentUsers = []; //variable to store current searching users data

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  getUsers() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot snap =
          await FirebaseFirestore.instance.collection('users').get();

      setState(() {
        users = snap.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Provider.of<ColorProvider>(context).backgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(labelText: 'Search for a user'),
          onChanged: (String _) {
            int len = searchController.text.length;
            setState(() {
              currentUsers = len == 0
                  ? users
                  : users
                      .where((user) =>
                          user['username'].substring(0, len) ==
                          searchController.text)
                      .toList();
            });
          },
          onTap: () {
            setState(() {
              currentUsers = users;
              isShowUsers = true;
            });
          },
        ),
        elevation: 1,
      ),
      body: isShowUsers
          ? isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: currentUsers.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(uid: currentUsers[index]['uid']),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            currentUsers[index]['photoUrl'],
                          ),
                          radius: 16,
                        ),
                        title: Text(
                          currentUsers[index]['username'],
                        ),
                      ),
                    );
                  })
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PostScreen(
                              snap: (snapshot.data! as dynamic).docs[index]),
                        ),
                      );
                    },
                    child: Image.network(
                      (snapshot.data! as dynamic).docs[index]['postUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  staggeredTileBuilder: (index) => StaggeredTile.count(
                    (index % 7 == 0) ? 2 : 1,
                    (index % 7 == 0) ? 2 : 1,
                  ),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                );
              }),
    );
  }
}
