import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wananzhuo/pages/about.dart';
import 'package:wananzhuo/pages/articleDetail.dart';
import './util/themeProvide.dart';
import './util/favoriteProvide.dart';
import './res/strings.dart';
import 'package:shared_preferences/shared_preferences.dart'; //持久化数据主要的作用是用于将数据异步持久化到磁盘，因为持久化数据只是存储到临时目录，当app删除时该存储的数据就是消失，web开发时清除浏览器存储的数据也将消失
import './res/colors.dart';
import './pages/homePage.dart';
import './pages/naviPage.dart';
import './pages/projectPage.dart';
import './pages/treeDetailPage.dart';
import './pages/searchPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './pages/about.dart';
import './pages/CollectPage.dart';
import './pages/articleDetail.dart';
import 'package:share/share.dart';
import 'package:wananzhuo/pages/loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  int themeIndex = await getTheme();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (ctx) => ThemeProvide()),
      ChangeNotifierProvider(
          create: (ctx) => FavoriteProvide()), //监听模型对象的变化，当数据改变时，它会重建Consumer
    ],
    child: MyApp(themeIndex),
  ));
}

Future<int> getTheme() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  int? themeIndex = sp.getInt(YColors.themeIndexKey);
  return themeIndex ?? 0;
}

class MyApp extends StatelessWidget {
  final int themeIndex;
  const MyApp(this.themeIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    final int? themeValue =
        context.watch<ThemeProvide>().value; // 调用ThemeProvide对象中的Value值
    print(themeValue);
    return MaterialApp(
      title: YStrings.appName,
      theme: ThemeData(
          //全局主题颜色、字体等定义
          primaryColor: YColors.themeColor[themeValue ?? themeIndex][
              'primaryColor'], //  ？？的用法如果themeValue为null则返回themeIndex否则返回themeValue
          primaryColorDark: YColors.themeColor[themeValue ?? themeIndex]
              ['primaryColorDark'],
          colorScheme: YColors.themeColor[themeValue ?? themeIndex]
              ['colorAccent'] //accentColor已经弃用
          ),
      home: MyHomePage(title: YStrings.appName)        //LoginPage()  
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String? title;
  const MyHomePage({super.key,this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String title = YStrings.appName;
  final _pageController = PageController(initialPage: 0);
  var pages = <Widget>[
    const HomePage(),
    const TreePage(),
    const NaviPage(),
    const ProjectPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(title),
        actions: <Widget>[
          IconButton(
              tooltip: '搜索',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchPage()));
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: PageView.builder(
          itemCount: pages.length,
          onPageChanged: _pageChange,
          controller: _pageController,
          itemBuilder: (BuildContext context, index) {
            return pages.elementAt(_selectedIndex);
          }),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: const Icon(Icons.home), label: YStrings.home),
            BottomNavigationBarItem(
                icon: const Icon(Icons.filter_list), label: YStrings.tree),
            BottomNavigationBarItem(
                icon: const Icon(Icons.low_priority), label: YStrings.navi),
            BottomNavigationBarItem(
                icon: const Icon(Icons.apps), label: YStrings.project)
          ],
          currentIndex: _selectedIndex, //默认选择
          type: BottomNavigationBarType.fixed,
          fixedColor: Theme.of(context).primaryColor, //选中颜色
          onTap: _onItemTapped),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: showToast,
        tooltip: '点击选中最后一个',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      drawer: showDrawer(),
    );
  }

  void _onItemTapped(int index) {
    //bottomNavigationBar 和 PageView 关联
    _pageController.animateToPage(index,
        duration: const Duration(microseconds: 300), curve: Curves.ease);
    print(_selectedIndex);
  }

  void _pageChange(int index) {
    setState(() {
      _selectedIndex = index;

      switch (index) {
        case 0:
          title = YStrings.appName;
          break;
        case 1:
          title = YStrings.tree;
          break;
        case 2:
          title = YStrings.navi;
          break;
        case 3:
          title = YStrings.project;
          break;
      }
      print('我执行了');
    });
  }

  void showToast() {
    Fluttertoast.showToast(
      msg: '选中最后一个',
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Theme.of(context).primaryColor,
      textColor: Colors.white,
      fontSize: 16,
    );
    _onItemTapped(3);
    print('执行toast');
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              currentAccountPicture: GestureDetector(
                //头像
                child: ClipOval(
                    //圆形头像
                    child: Image.network(
                        'https://profile-avatar.csdnimg.cn/f81b97e9519148ac9d7eca7681fb8698_yechaoa.jpg!1')),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutPage()));
                },
              ),
              otherAccountsPictures: <Widget>[
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ArticleDetail(
                                  url:
                                      "https://github.com/yechaoa/wanandroid_flutter",
                                  title: "来都来了,点个star吧🌹")));
                    },
                    icon: const Icon(Icons.star, color: Colors.white))
              ],
              accountName: Text(
                YStrings.proName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              accountEmail: Text(YStrings.github)),
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text('我的收藏'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CollectPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('切换主题'),
            trailing: const Icon(Icons.chevron_right),
            onTap: (){
              Navigator.of(context).pop();
              showThemeDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text("我要分享"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).pop();
              Share.share('【玩安卓Flutter版】\nhttps://github.com/yechaoa/wanandroid_flutter');
            },
          )
        ],
      ),
    );
  }
  void showThemeDialog(){
    showDialog(context: context,
    barrierDismissible: true,
     builder: (BuildContext context){
      return AlertDialog(
        title: const Text('切换主题'),
        content: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              shrinkWrap:true ,
              itemCount: YColors.themeColor.keys.length,
              itemBuilder:(BuildContext context , position){
                return GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.only(bottom: 15),
                    color: YColors.themeColor[position]['primaryColor'],
                  ),
                  onTap: ()async{
                    context.read<ThemeProvide>().setTheme(position);

                    SharedPreferences sp = await SharedPreferences.getInstance();
                    sp.setInt(YColors.themeIndexKey, position);
                    Navigator.of(context).pop();
                  },
                );
              }),
          ),
        ),
      );

     });
  }
}
