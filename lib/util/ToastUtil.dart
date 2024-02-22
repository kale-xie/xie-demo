import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



class YToast {
  static show({
    @required BuildContext? context,
    @required String? msg,
    Toast? toastLength,
    int timeInSecForIos = 1,
    double fontSize = 16.0,
    ToastGravity? gravity,
    Color? backgroundColor,
    Color? textColor,
  }) {
    Fluttertoast.showToast(
        msg: msg!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context!).primaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static showBottom({
    @required BuildContext? context,
    @required String? msg,
    Toast? toastLength,
    int timeInSecForIos = 1,
    double fontSize = 16.0,
    ToastGravity? gravity,
    Color? backgroundColor,
    Color? textColor,
  }) {
    Fluttertoast.showToast(
        msg: msg!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context!).primaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}