import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/saved_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:provider/provider.dart';

import '../providers/color_provider.dart';
import '../providers/user_provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
    pageController = PageController();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          FeedScreen(),
          SearchScreen(),
          AddPostScreen(),
          SavedScreen(),
          ProfileScreen(uid: Provider.of<UserProvider>(context).getUser.uid),
        ],
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 5),
        child: CupertinoTabBar(
          border: Border(bottom: BorderSide(color: Colors.transparent)),
          backgroundColor: Provider.of<ColorProvider>(context).backgroundColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _page == 0
                    ? Provider.of<ColorProvider>(context).primaryColor
                    : secondaryColor,
              ),
              label: '',
              backgroundColor: Provider.of<ColorProvider>(context).primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _page == 1
                    ? Provider.of<ColorProvider>(context).primaryColor
                    : secondaryColor,
              ),
              label: '',
              backgroundColor: Provider.of<ColorProvider>(context).primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: _page == 2
                    ? Provider.of<ColorProvider>(context).primaryColor
                    : Provider.of<ColorProvider>(context).secondaryColor,
              ),
              label: '',
              backgroundColor: Provider.of<ColorProvider>(context).primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: _page == 3
                    ? Provider.of<ColorProvider>(context).primaryColor
                    : Provider.of<ColorProvider>(context).secondaryColor,
              ),
              label: '',
              backgroundColor: Provider.of<ColorProvider>(context).primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _page == 4
                    ? Provider.of<ColorProvider>(context).primaryColor
                    : Provider.of<ColorProvider>(context).secondaryColor,
              ),
              label: '',
              backgroundColor: Provider.of<ColorProvider>(context).primaryColor,
            ),
          ],
          onTap: navigationTapped,
        ),
      ),
    );
  }
}
