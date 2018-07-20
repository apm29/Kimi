import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_office/images.dart';
import 'dart:io';

class SplashPage extends StatelessWidget {
  Widget build(BuildContext context) {
    checkProfile();

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

  void checkProfile() {}
}
