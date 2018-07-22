import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_office/images.dart';

import 'package:flutter_office/model/api.dart';

class SplashPage extends StatelessWidget {
  final CancelToken cancelToken = new CancelToken();

  Widget build(BuildContext context) {
    return Container(
        padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        color: Colors.white,
        child: new Image.asset(
          splash,
          fit: BoxFit.fill,
        ));
  }

  void toMain() {
    new Timer(Duration(seconds: 2), () {});
  }

  void checkProfile() {
    profile().then((v) {
      print(v);
    });
  }
}
