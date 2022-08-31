import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/color_provider.dart';
import 'package:instagram_clone/widgets/user_list.dart';
import 'package:provider/provider.dart';

class UserListScreen extends StatefulWidget {
  UserListScreen({Key? key, required this.title, required this.users}) : super(key: key);
  final String title;
  final List users;

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Provider.of<ColorProvider>(context).backgroundColor,
      ),
      body: UserList(users: widget.users),
    );
  }
}