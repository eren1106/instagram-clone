import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class ColorProvider with ChangeNotifier {
  bool _isDark = true;

  bool get getIsDark => _isDark;
  
  Color backgroundColor = Color.fromARGB(255, 10, 10, 10);
  Color blueColor = Color.fromRGBO(0, 149, 246, 1);
  Color primaryColor = Colors.white;
  Color secondaryColor = Colors.grey;

  // Object _colorObject = {
  //   backgroundColor: Color.fromRGBO(0, 0, 0, 1),
  //   blueColor: Color.fromRGBO(0, 149, 246, 1),
  //   primaryColor: Colors.white,
  //   secondaryColor: Colors.grey,
  // };

  // Object get getColorObject{
  //   return _colorObject;
  // }

  void toggleDark() {
    _isDark = !_isDark;
    assignColor();
    notifyListeners();
  }

  void assignColor(){
    backgroundColor = _isDark ? Color.fromARGB(255, 10, 10, 10) : Colors.white;
    primaryColor = _isDark ? Colors.white : Colors.black;
  }
}

