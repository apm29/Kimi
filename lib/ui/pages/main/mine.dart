import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_office/model/api.dart';
import 'package:flutter_office/ui/pages/login.dart';
import 'package:flutter_office/ui/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MineFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MineState();
  }
}

class MineState extends State<MineFragment> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
          child: new ListView(
            shrinkWrap: true,
        physics:  new ClampingScrollPhysics(),
        children: <Widget>[
          new JunButton(() {
            SharedPreferences.getInstance().then((instance) {
              instance.clear();
              Navigator
                  .of(context)
                  .pushReplacement(new MaterialPageRoute(builder: (context) {
                return new LoginPage();
              }));
            });
          }, "退出"),
          new JunButton(() {
            SharedPreferences.getInstance().then((instance) {
              instance.clear();
              profile(context, new CancelToken());
            });
          }, "profile"),
          new Hero(
            tag: "hero-new-page",
            child: new JunButton(() {
              Navigator.push(context, new MaterialPageRoute(builder: (context) {
                return new BlankPage();
              }));
            }, "new page"),
          ),
        ],
      )),
    );
  }
}

class BlankPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
          child: new ListView(
        children: <Widget>[
          new JunButton(() {
            SharedPreferences.getInstance().then((instance) {
              instance.clear();
              profile(context, new CancelToken());
            });
          }, "profile"),
          new Hero(
            tag: "hero-new-page",
            child: new JunButton(() {
              Navigator.push(context, new MaterialPageRoute(builder: (context) {
                return new BlankPage();
              }));
            }, "new page"),
          ),
          new Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Expanded(flex: 2,child: new Container(color:Colors.amber,child: new Text("A"))),
              new Container(color:Colors.blue,child: new Text("B")),
              new Expanded(child: new Container(color:Colors.lightGreenAccent,child: new Text("C"))),
            ],
          )
        ],
      )),
    );
  }
}
