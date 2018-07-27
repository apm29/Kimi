import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_office/images.dart';

import 'package:flutter_office/model/api.dart';
import 'package:flutter_office/model/model.dart';
import 'package:flutter_office/ui/pages/main.dart';
import 'package:flutter_office/ui/pages/login.dart';

class SplashPage extends StatelessWidget {
  final CancelToken cancelToken = new CancelToken();

  @override
  StatelessElement createElement() {
    print("create Element");
    return super.createElement();
  }

  Widget build(BuildContext context) {
    checkPermissions(context);
    return Container(
        padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        color: Colors.white,
        child: new Image.asset(
          splash,
          fit: BoxFit.cover,
        ));
  }

  void toMain(BuildContext context) {
    new Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (context) {
        return new MainPage();
      }));
    });
  }

  void checkProfile(BuildContext context) {
    profile(cancelToken).then((v) {
      BaseResp<Profile> resp = new BaseResp<Profile>(v.data);
      if (resp.isSuccess()) {
        if (resp.data.type != 0) {
          toMain(context);
        } else if (resp.data.is_real != 0) {
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
    new Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (context) {
        return new LoginPage();
      }));
    });
  }

  void checkPermissions(BuildContext context) {
    checkProfile(context);
  }
}
