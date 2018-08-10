import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_office/model/api.dart';
import 'package:flutter_office/ui/pages/application/form_page.dart';
import 'package:flutter_office/ui/pages/login.dart';
import 'package:flutter_office/ui/widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

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
        physics: new ClampingScrollPhysics(),
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
          new JunButton(() {
            Navigator.push(context, new MaterialPageRoute(builder: (_){
              return new FormPage();
            }));
          }, "NEW API"),
        ],
      )),
    );
  }
}

class BlankPage extends StatefulWidget {
  @override
  BlankPageState createState() {
    return new BlankPageState();
  }
}

class BlankPageState extends State<BlankPage>
    with TickerProviderStateMixin<BlankPage> {
  @override
  Widget build(BuildContext context) {
    final globalKey = new GlobalKey(debugLabel: "123");
    var screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new TextFormField(),
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
              new Expanded(
                  child: new Container(
                      alignment: AlignmentDirectional.center,
                      color: Colors.amber,
                      child: new Text("A"))),
              new Expanded(
                  child: new Container(
                      alignment: AlignmentDirectional.center,
                      color: Colors.blue,
                      child: new Text("B"))),
              new Expanded(
                  child: new Container(
                      alignment: AlignmentDirectional.center,
                      color: Colors.lightGreenAccent,
                      child: new Text("C"))),
            ],
          ),
          Container(
            key: globalKey,
            color: Colors.indigo,
            width: screenSize.width / 4,
            height: screenSize.height / 4,
            alignment: AlignmentDirectional.center,
            child: new GestureDetector(
              onTap: () {
                HapticFeedback.vibrate();

                doAnim(globalKey, context);
              },
              child: new Text("vibrate"),

            ),
          ),
        ],
      ),
    );
  }

  void doAnim(
      GlobalKey<State<StatefulWidget>> globalKey, BuildContext context) {
    var object = globalKey.currentContext?.findRenderObject();
    var translation = object?.getTransformTo(null)?.getTranslation();
    var size = object?.semanticBounds?.size;

    var rect = new Rect.fromLTWH(
        translation.x, translation.y, size.width, size.height);
    var screenSize = MediaQuery.of(context).size;
    var scaleHeight = screenSize.height / size.height;
    var overlayState = Overlay.of(context);
    var animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
      upperBound: scaleHeight,
      lowerBound: 1.0,
    );
    OverlayEntry entry = new OverlayEntry(builder: (context) {
      return new Positioned.fromRect(
          rect: rect,
          child: new AnimatedBuilder(animation: animationController, builder: (context,widget){
            var x = -(rect.left/scaleHeight)*animationController.value/scaleHeight;
            var y = -(rect.top/scaleHeight)*animationController.value/scaleHeight;
            Matrix4 matrixMove = new Matrix4.identity()
            ..scale(animationController.value)
            ..translate(x,y);
            var offset = new Offset(size.width / 2 - rect.left - rect.width / 2,
                size.height / 2 - rect.top - rect.height / 2);
            offset *= (animationController.value/scaleHeight);
            var flipMatrix4 = MatrixUtils.createCylindricalProjectionTransform(
                radius: 0.0,

                ///翻转90°
                angle: -animationController.value/scaleHeight * pi / 2,
                orientation: Axis.horizontal);
            return new Transform(
              transform: matrixMove,
              child: new Stack(
                children: <Widget>[
                  new Container(
                    color: Colors.redAccent,
                  ),
                  new Container(
                    transform: flipMatrix4,
                    color: Colors.indigo,
                  ),

                ],
              ),
            );
          }));
    });
    overlayState.insert(entry);
    animationController.forward().whenComplete((){
      entry.remove();
    });
  }
}
