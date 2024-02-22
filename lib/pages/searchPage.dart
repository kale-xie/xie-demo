import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wananzhuo/common/api.dart';
import 'package:wananzhuo/entity/article_entity.dart';
import 'package:wananzhuo/entity/hot_key_entity.dart';
import 'package:wananzhuo/http/httpUtil.dart';
import 'package:wananzhuo/pages/articleDetail.dart';
import 'package:wananzhuo/res/colors.dart';
import './articleDetail.dart';

List<ArticleDataData> articleDatas = [];
List<HotKeyData> hotKeyDatas = [];
String key = "";
var pageContext;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();

    getHttpByHoyKey();
    print(hotKeyDatas);
  }

  void getHttpByHoyKey() async {
    try {
      print('我hotkey被执行了哦');
      var hotKeyResponse = await HttpUtil().post(Api.HOT_KEY);

      ///Http()重新封装了一个Dio
      print('我hotMap要被赋值了哦');
      Map hotKeyMap = json.decode(hotKeyResponse.toString());
      print(hotKeyMap);
      print('我hotMap被赋值成功了哦');
      var hotKeyEntity = HotKeyEntity.fromJson(hotKeyMap);
      print('我hotKeyEntity被赋值成功了哦');
      print(hotKeyEntity.data);

      setState(() {
        hotKeyDatas = hotKeyEntity.data!;
        print('我hotkey被赋值了哦');
      });

      showSearch(context: context, delegate: MysearchDelegate('输入你想要搜索的内容~'));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    pageContext = context;
    return const Scaffold(
      backgroundColor: Colors.white,
      body: null,
    );
  }

  void getHttpByKey(String key) async {
    try {
      var data = {'k': key};
      var articleResponce = await HttpUtil().post(Api.QUERY, data: data);
      Map articleMap = json.decode(articleResponce.toString());
      var articleEntity = ArticleEntity.fromJson(articleMap);

      setState(() {
        articleDatas = articleEntity.data!.datas!;
        print(articleDatas);
      });
    } catch (e) {
      print(e);
    }
  }
}

class MysearchDelegate extends SearchDelegate<String> {
  MysearchDelegate(String hinText)
      : super(
            searchFieldLabel: hinText,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            searchFieldStyle: const TextStyle(color: Colors.black));

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      TextButton(
        child: const Text(
          '搜索',
          style: TextStyle(fontSize: 18, color: YColors.color_666),
        ),
        onPressed: () async {
          var data = {'k': query};
          var articleResponse = await HttpUtil().post(Api.QUERY, data: data);
          print(articleResponse);
          Map articleMap = json.decode(articleResponse.toString());

          print('搜索被执行Q');
          print(articleMap);
          var articleEntity = ArticleEntity.fromJson(articleMap);
          print('搜索被执行T');
          articleDatas = articleEntity.data!.datas!;
          print(articleDatas);
          showResults(context);
        },
      ),
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
        Navigator.of(pageContext).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults

    return ListView.builder(
        itemCount: articleDatas.length,
        itemBuilder: (BuildContext context, int position) {
          // if (position.isOdd)

          const Divider(
            color: Colors.black,
          );
          print('执行$position');
          return GestureDetector(
              child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text(
                    articleDatas[position]
                        .title!
                        .replaceAll("<em class='highlight'>", "【")
                        .replaceAll("<\/em>", "】"),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                            constraints: BoxConstraints(maxWidth: 150),
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.0),
                              borderRadius: BorderRadius.circular((20.0)),
                            ),
                            child: Text(
                              articleDatas[position].superChapterName!,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )),
                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: Text(articleDatas[position].author!),
                        )
                      ],
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
              const Divider(color: Color.fromARGB(255, 221, 21, 21))
            ],
          ),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleDetail(
                  
                  url: articleDatas[position].link!, 
                  title: articleDatas[position].title!.replaceAll("<em class='highlight'>", "").replaceAll("<\/em>", "")
                  ))

            );
          },);
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:<Widget> [
          Text('大家都在搜：',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: YColors.color_666,
            ),),
            SizedBox(height: 10),
            Wrap(
              spacing: 10.0,
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              children: List<Widget>.generate(hotKeyDatas.length, (int index) {
                return ActionChip(label: Text(
                  hotKeyDatas[index].name!,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                ),
                onPressed: () async {
                  query = hotKeyDatas[index].name!;
                  key = query;
                  var data = {'k': key};
                  var articleResponse = await HttpUtil().post(Api.QUERY,data: data);
                  Map articleMap = json.decode( articleResponse.toString());
                  var articleEntity = ArticleEntity.fromJson(articleMap);

                  articleDatas = articleEntity.data!.datas!;

                  showResults(context);



                },
                elevation: 3,
                backgroundColor: Colors.blue,);
              },).toList(),

            ),
        ],

      ),

    );
  }
}
