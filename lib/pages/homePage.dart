import 'dart:convert';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:wananzhuo/common/api.dart';
import 'package:wananzhuo/entity/article_entity.dart';
import 'package:wananzhuo/entity/banner_entity.dart';
import 'package:wananzhuo/entity/common_entity.dart';
import 'package:wananzhuo/pages/articleDetail.dart';
import 'package:wananzhuo/entity/article_entity.dart';
import 'package:wananzhuo/http/httpUtil.dart';
import 'package:flutter/material.dart';
import 'package:wananzhuo/res/colors.dart';
import 'package:wananzhuo/util/ToastUtil.dart';

import './loginPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BannerData> bannerDatas = [];
  List<ArticleDataData> articleDatas = [];
  EasyRefreshController? _easyRefreshController;
  SwiperController? _swiperController;

  int _page = 0;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();

    _easyRefreshController = EasyRefreshController(
      controlFinishLoad: true,
      controlFinishRefresh: true,
    );

    _swiperController = SwiperController();

    getHttp();
  }

  void getHttp() async {
    try {
      var bannerResponse = await HttpUtil().get(Api.BANNER);
      Map bannerMap = json.decode(bannerResponse.toString());
      var bannerEntity = BannerEntity.fromJson(bannerMap);

      var articleResponse =
          await HttpUtil().get(Api.ARTICLE_LIST + "$_page/json");
      Map articleMap = json.decode(articleResponse.toString());
      var articleEntity = ArticleEntity.fromJson(articleMap);
      print('执行抓取广告');

      setState(() {
        bannerDatas = bannerEntity.data!;
        articleDatas = articleEntity.data!.datas!;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.builder(
          controller: _easyRefreshController,
          header: const PhoenixHeader(
            skyColor: YColors.colorPrimary,
            position: IndicatorPosition.locator,
            safeArea: false,
          ),
          footer: const PhoenixFooter(
            skyColor:Colors.white,// YColors.colorPrimary,
            position: IndicatorPosition.locator,
          ),
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1), () {
              if (!mounted) {
                return;
              }
              setState(() {
                _page = 0;
              });
              getHttp();

              _easyRefreshController?.finishRefresh();
              _easyRefreshController?.resetFooter();
            });
          },
          onLoad: () async {
            await Future.delayed(Duration(seconds: 1), () {
              if (!mounted) {
                return;
              }
              setState(() {
                _page++;
              });
              getMoreData();

              _easyRefreshController?.finishLoad(
                  hasMore ? IndicatorResult.success : IndicatorResult.noMore);
            });
          },
          childBuilder: (context, physics) {
            return CustomScrollView(
              physics: physics,
              slivers: [
                SliverAppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  expandedHeight:
                      MediaQuery.of(context).size.width / 1.8 * 0.8 +
                          20, // +20 是上下的padding值
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: getBanner(),
                  ),
                ),
                const HeaderLocator.sliver(),
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  return getRow(index, articleDatas.length);
                }, childCount: articleDatas.length)),
                const FooterLocator.sliver()
              ],
            );
          }),
    );
  }

  Widget? getRow(int i, int length) {
    if (length == 0) return null;

    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: IconButton(
            icon: articleDatas != null && articleDatas[i].collect!
                ? Icon(
                    Icons.favorite,
                    color: Theme.of(context).primaryColor,
                  )
                : Icon(Icons.favorite_border),
            tooltip: '收藏',
            onPressed: () {
              if (articleDatas[i].collect!) {
                cancelCollect(articleDatas[i].id!);
              } else {
                addCollect(articleDatas[i].id!);
              }
            },
          ),
            title: Text(
              articleDatas[i].title!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
             subtitle: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                children: <Widget>[
                  Container(
                      constraints: BoxConstraints(maxWidth: 150),
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular((20.0)), // 圆角度
                      ),
                      child: Text(articleDatas[i].superChapterName!,
                          style: TextStyle(color: Theme.of(context).primaryColor),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1)),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(articleDatas[i].author!),
                  ),
                ],
              ),
            ),
            trailing: Icon(Icons.chevron_right),
        ),
      ),
       onTap: () {
        if (0 == 1) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetail(title: articleDatas[i].title!, url: articleDatas[i].link!),
          ),
        );
      },
    );
  }

  Widget getBanner() {
    return Container(
      width: MediaQuery.of(context).size.width,
      //1.8是banner宽高比，0.8是viewportFraction的值
      height: MediaQuery.of(context).size.width / 1.8 * 0.8,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Swiper(
        itemCount: bannerDatas.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular((10.0)), // 圆角度
              image: DecorationImage(
                image: NetworkImage(bannerDatas[index].imagePath!),
                fit: BoxFit.fill,
              ),
            ),
          );
        },
        loop: false,
        autoplay: true,
        autoplayDelay: 3000,
        //触发时是否停止播放
        autoplayDisableOnInteraction: true,
        duration: 600,
        //默认分页按钮
        controller: _swiperController,
        //默认指示器
        pagination: SwiperPagination(
          // SwiperPagination.fraction 数字1/5，默认点
          builder: DotSwiperPaginationBuilder(size: 6, activeSize: 9),
        ),

        //视图宽度，即显示的item的宽度屏占比
        viewportFraction: 0.8,
        //两侧item的缩放比
        scale: 0.9,

        onTap: (int index) {
          //点击事件，返回下标
          print("index-----" + index.toString());
        },
      ),
    );
  }

  Future addCollect(int id) async {
    var collectResponse = await HttpUtil().post(Api.COLLECT + '$id/json');
    Map map = json.decode(collectResponse.toString());
    var entity = CommonEntity.fromJson(map);
    if (entity.errorCode == -1001) {
      YToast.showBottom(context: context, msg: entity.errorMsg);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      YToast.showBottom(context: context, msg: "收藏成功");
      getHttp();
    }
  }

  Future cancelCollect(int id) async {
    var collectResponse =
        await HttpUtil().post(Api.UN_COLLECT_ORIGIN_ID + '$id/json');
    Map map = json.decode(collectResponse.toString());
    var entity = CommonEntity.fromJson(map);
    if (entity.errorCode == -1001) {
      YToast.show(context: context, msg: entity.errorMsg);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      YToast.show(context: context, msg: "取消成功");
      getHttp();
    }
  }

  Future getMoreData() async {
    var response = await HttpUtil().get(Api.ARTICLE_LIST + '$_page/json');
    Map map = json.decode(response.toString());
    var articleEntity = ArticleEntity.fromJson(map);
    setState(() {
      articleDatas.addAll(articleEntity.data!.datas!);
      if (articleEntity.data!.datas!.length < 10) {
        hasMore = false;
      }
    });
    
  }
  @override
  void dispose() {
    _easyRefreshController?.dispose();
    _swiperController?.stopAutoplay();
    _swiperController?.dispose();
    super.dispose();
  }
}
