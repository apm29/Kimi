import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_office/images.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeState();
  }
}

class HomeState extends State<HomePage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return new CupertinoTabScaffold(
      tabBar: new CupertinoTabBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Image.asset(currentIndex==0?ic_home_selected:ic_home_unselected), title: new Text("首页")),
          new BottomNavigationBarItem(
              icon: new Image.asset(currentIndex==1?mine_selected:mine_unselected), title: new Text("我的"))
        ],
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },
      ),
      tabBuilder: (BuildContext context, int index) {
        return new Container(
          color: Colors.green,
        );
      },

    );
  }
}
