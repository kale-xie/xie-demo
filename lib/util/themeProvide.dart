import 'package:flutter/material.dart';

class ThemeProvide with ChangeNotifier {
   int? _themeIndex;

  // int _themeIndex = 0;  //初始化一下
  int? get value => _themeIndex;

  ThemeProvide();

  void setTheme(int index) async {
    _themeIndex = index;
    notifyListeners(); //重建Consumer的UI
  }
}
