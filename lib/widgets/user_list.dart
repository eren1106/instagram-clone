import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/profile_screen.dart';

class UserList extends StatelessWidget {
  const UserList({
    Key? key,
    required this.users,
  }) : super(key: key);

  final List users;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(uid: users[index]['uid']),
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(users[index]['photoUrl'],),
                radius: 16,
              ),
              title: Text(
                users[index]['username'],
              ),
            ),
          );
        });
  }
}