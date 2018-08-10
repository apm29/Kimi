import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_office/images.dart';
import 'package:flutter_office/main.dart';

import 'package:flutter_office/model/api.dart';
import 'package:flutter_office/model/model.dart';
import 'package:flutter_office/text_style.dart';
import 'package:flutter_office/ui/pages/main.dart';
import 'package:flutter_office/ui/pages/login.dart';

const splash_time = 1;

class SplashPage extends StatefulWidget {
  final CancelToken cancelToken = new CancelToken();

  @override
  SplashPageState createState() {
    return new SplashPageState();
  }

  void toMain(BuildContext context) {
    new Timer(Duration(seconds: splash_time), () {
      Navigator.pushReplacement(context,
          new PageRouteBuilder(pageBuilder: (_, __, ___) {
        return new MainPage();
      }));
    });
  }

  void checkProfile(BuildContext context) {
    profile(context, cancelToken).then((resp) {
      BaseResp<UserProfile> baseResp = new BaseResp<UserProfile>(resp.data);
      if (baseResp.isSuccess()) {
        if (baseResp.data.type != 0) {
          toMain(context);
        } else if (baseResp.data.is_real != 0) {
          toMain(context);
        } else {
          toLogin(context);
        }
      } else {
        toLogin(context);
      }
    }, onError: (e) {
      toLogin(context);
    });
  }

  void toLogin(BuildContext context) {
    new Timer(Duration(seconds: splash_time), () {
      Navigator.pushReplacement(context,
          new PageRouteBuilder(pageBuilder: (_, __, ___) {
        return new LoginPage();
      }));
    });
  }

  void checkPermissions(BuildContext context) {
    checkProfile(context);
  }
}

class SplashPageState extends State<SplashPage> with TickerProviderStateMixin<SplashPage>{
  Widget build(BuildContext context) {
    widget.checkPermissions(context);
    AnimationController controller = new AnimationController(vsync: this,duration: new Duration(seconds: 1));
    controller.forward();
    return new Scaffold(
        body: new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Hero(
            tag: "hero-tag-ic-launcher",
            child: new Image.asset(
              launcher,
              height: 72.0,
              width: 72.0,
            ),
          ),
          new Container(
            height: 32.0,
          ),
          new Text(
            "君磊助手",
            style: headerTitleStyle.copyWith(color: gold),
          ),
          new Container(
            height: 48.0,
          ),
          new Text(
            "『进件速度快,结果快速反馈』",
            style: headerTitleStyle.copyWith(color: gold),
          ),
        ],
      ),
    ));
  }
}
