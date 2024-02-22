import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:share/share.dart';
import 'package:wananzhuo/res/colors.dart';



class ArticleDetail extends StatelessWidget {
  final String url;
  final String title;



  const ArticleDetail({super.key,required this.url,required this.title});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     theme: ThemeData(
        primaryColor: Theme.of(context).primaryColor,
      ),
      routes: {
        "/": (_) =>  WebviewScaffold(
              url: '$url',
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                //返回键 点击关闭
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.maybePop(context);
                    }),
                title: Text("$title"),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.share),
                    tooltip: '分享',
                    onPressed: () {
                      Share.share('【$title】\n$url');
                    },
                  ),
                ],
              ),
            ),
      },
    );
  }
}