import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wananzhuo/common/api.dart';
import 'package:wananzhuo/entity/user_entity.dart';
import 'package:wananzhuo/http/httpUtil.dart';
import 'package:wananzhuo/main.dart';
import 'package:wananzhuo/res/colors.dart';
import 'package:wananzhuo/util/ToastUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../res/strings.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  var tabs = <Tab>[];
  String btnText = '登录';
  String bottomText = '没有账号？注册';
  bool visible = true;
  final GlobalKey<FormState> _key = GlobalKey();
  bool autoValidate = false;
  String? username, password, rePassword;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Theme.of(context).primaryColor,
          colorScheme: const ColorScheme.dark(),
          primaryColorDark: Theme.of(context).primaryColorDark),
      home: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColorDark
            ])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: getBodyView(),
        ),
      ),
    );
  }

  Widget getBodyView() {
    return ListView(
      children: <Widget>[
        const SizedBox(height: 80),
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 50),
                padding: EdgeInsets.all(40),
                child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: _key,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.person_outline),
                                  labelText: '请输入账号',
                                ),
                                validator: validateUsername,
                                onSaved: (text) {
                                  setState(() {
                                    username = text;
                                  });
                                },
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                obscureText: true,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.lock_outline),
                                  labelText: '请输入密码',
                                ),
                                validator: validatePassword,
                                onSaved: (text) {
                                  setState(() {
                                    password = text;
                                  });
                                },
                              ),
                              SizedBox(height: 20),
                              Offstage(
                                offstage: visible,
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      obscureText: true,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.lock_outline),
                                        labelText: '请确认密码',
                                      ),
                                      validator:
                                          visible ? null : validateRePassword,
                                      onSaved: (text) {
                                        setState(() {
                                          rePassword = text;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                            ]),
                      ),
                    ))),
            Positioned(
                top: 40,
                left: MediaQuery.of(context).size.width / 2 - 35,
                child: Center(
                    child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage('lib\res\images\ic_logo.png'),
                      ),
                      boxShadow: [
                        BoxShadow(
                          //左右、上下阴影的距离
                          offset: Offset(0, 0),
                          //阴影颜色
                          color: Colors.grey,
                          //模糊距离
                          blurRadius: 8,
                          //不模糊距离
                          spreadRadius: 1,
                        ),
                      ]),
                ))),
            Positioned(
                bottom: 20,
                left: 130,
                right: 130,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      btnText,
                      style: TextStyle(color: YColors.color_fff, fontSize: 20),
                    ),
                  ),
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      _key.currentState!.save();
                      print(username! + "--" + password! + "**" + rePassword!);
                      doRequest();
                    } else {
                      setState(() {
                        autoValidate = true;
                      });
                    }
                  },
                ))
          ],
        ),
        GestureDetector(
          child: Text(
            bottomText,
            style: TextStyle(color: YColors.color_fff),
            textAlign: TextAlign.center,
          ),
          onTap: () {
            setState(() {
              if (visible) {
                btnText = "注册";
                visible = false;
                bottomText = "已有账号？登录";
              } else {
                btnText = "登录";
                visible = true;
                bottomText = "没有账号？注册";
              }
            });
          },
        ),
      ],
    );
  }

  String? validateUsername(value) {
    if (value.isEmpty)
      return '账号不能为空';
    else if (value.length < 6) return '账号最少6位';
    return null;
  }

  String? validatePassword(value) {
    if (value.isEmpty)
      return '密码不能为空';
    else if (value.length < 6) return '密码最少6位';
    return null;
  }

  String? validateRePassword(value) {
    if (value.isEmpty)
      return '确认密码不能为空';
    else if (value != password) return '两次密码不一致';
    return null;
  }

  Future doRequest() async {
    var data;
    if (visible)
      data = {'username': username, 'password': password};
    else
      data = {
        'username': username,
        'password': password,
        'repassword': rePassword
      };

    var response = await HttpUtil().post(visible ? Api.LOGIN : Api.REGISTER, data: data);

    List<String> cookies = response.headers['set-cookie'];
    print('这是持久化的-----------------------$cookies');
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setStringList('cookies',cookies);
    Map userMap = json.decode(response.toString());
    print('这是登录成功的标识$userMap');
    var userEntity = UserEntity.fromJson(userMap);
    if (userEntity.errorCode == 0) {
      YToast.show(context: context, msg: visible ? "登录成功~" : "注册成功~");
      //跳转并关闭当前页面
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
        (route) => route == null,
      );
    } else
      YToast.show(context: context, msg: userMap['errorMsg']);
  }
}
