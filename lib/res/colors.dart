import 'package:flutter/material.dart';

class YColors {
  static const Color colorPrimary = Color(0xff4caf50);
  static const Color colorPrimaryDark = Color(0xff388E3C);
  static const Color colorAccent = Color(0xff8BC34A);
  static const Color colorPrimaryLight = Color(0xffC8E6C9);

  static const Color primaryText = Color(0xff212121);
  static const Color secondaryText = Color(0xff757575);

  static const Color dividerColor = Color(0xffBDBDBD);

  static const Color bg = Color(0xffF9F9F9);
  // ignore: constant_identifier_names
  static const Color color_F9F9F9 = Color(0xffF9F9F9);

  static const Color color_999 = Color(0xff999999);
  static const Color color_666 = Color(0xff666666);

  // ignore: constant_identifier_names
  static const Color color_f3f3f3 = Color(0xfff3f3f3);
  // ignore: constant_identifier_names
  static const Color color_f1f1f1 = Color(0xfff1f1f1);
  // ignore: constant_identifier_names
  static const Color color_fff = Color(0xffffffff);

  // 主题下标key
  static const String themeIndexKey = "themeIndex";

  /* 主题列表 */
  static  Map themeColor = {
    0: {//green
      "primaryColor": const Color(0xff4caf50),
      "primaryColorDark": const Color(0xff388E3C),
      "colorAccent": ColorScheme.fromSwatch().copyWith(secondary: const   Color(0xffFF5252)),
      "colorPrimaryLight": const Color(0xffC8E6C9),
    },
    1:{//red
      "primaryColor": const Color(0xffF44336),
      "primaryColorDark": const Color(0xffD32F2F),
      "colorAccent":ColorScheme.fromSwatch().copyWith(secondary: const   Color(0xffFF5252)),
      "colorPrimaryLight": const Color(0xffFFCDD2),
    },
    2:{//blue
      "primaryColor": const Color(0xff2196F3),
      "primaryColorDark": const Color(0xff1976D2),
      "colorAccent": ColorScheme.fromSwatch().copyWith(secondary: const   Color(0xff448AFF)),
      "colorPrimaryLight": const Color(0xffBBDEFB),
    },
    3:{//pink
      "primaryColor": const Color(0xffE91E63),
      "primaryColorDark": const Color(0xffC2185B),
      "colorAccent":ColorScheme.fromSwatch().copyWith(secondary: const Color(0xffFF4081)),
      "colorPrimaryLight": const Color(0xffF8BBD0),
    },
    4:{//purple
      "primaryColor": const Color(0xff673AB7),
      "primaryColorDark": const Color(0xff512DA8),
      "colorAccent": ColorScheme.fromSwatch().copyWith(secondary: const   Color(0xff7C4DFF)),
      "colorPrimaryLight": const Color(0xffD1C4E9),
    },
    5:{//grey
      "primaryColor": const Color(0xff9E9E9E),
      "primaryColorDark": const Color(0xff616161),
      "colorAccent": ColorScheme.fromSwatch().copyWith(secondary: const   Color(0xff9E9E9E)),
      "colorPrimaryLight": const Color(0xffF5F5F5),
    },
    6:{//black
      "primaryColor": const Color(0xff333333),
      "primaryColorDark": const Color(0xff000000),
      "colorAccent": ColorScheme.fromSwatch().copyWith(secondary: const   Color(0xff666666)),
      "colorPrimaryLight": const Color(0xff999999),
    },
  };

}