import 'package:flutter/material.dart';
import 'package:flutter_office/images.dart';
import 'package:flutter_office/model/api.dart';
import 'package:flutter_office/ui/pages/main/home.dart';
import 'package:flutter_office/ui/pages/main/mine.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainState();
  }
}

class MainState extends State<MainPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    add401Interceptor(context);
    return new Container(
      padding: new EdgeInsets.all(0.0),
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          new Expanded(
              child:
                  currentIndex == 0 ? new HomeFragment() : new MineFragment()),
          new BottomNavigationBar(
            currentIndex: currentIndex,
            items: [
              new BottomNavigationBarItem(
                  icon: new Image.asset(
                    currentIndex == 0 ? ic_home_selected : ic_home_unselected,
                    height: currentIndex == 0 ? 24.0 : 20.0,
                  ),
                  title: new Text("首页")),
              new BottomNavigationBarItem(
                  icon: new Image.asset(
                      currentIndex == 1 ? mine_selected : mine_unselected,
                      height: currentIndex == 1 ? 24.0 : 20.0),
                  title: new Text("我的"))
            ],
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
