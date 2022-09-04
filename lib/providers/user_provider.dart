import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
    email: "",
    uid: "",
    photoUrl: "",
    username: "",
    bio: "",
    followers: [],
    following: [],
    saved: [],
  ); // initiate all values so that no error occur

  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
