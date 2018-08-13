import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_office/main.dart';
import 'package:flutter_office/text_style.dart';

abstract class CallBack {
  bool doObscure(bool obscure);
}

class TextInput extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final obscure;

  final int maxLength;

  TextInput(
      {this.hint = "", this.controller, this.obscure = false, this.maxLength});

  @override
  State<StatefulWidget> createState() {
    return new TextState(
        hint: hint,
        controller: controller,
        obscure: obscure,
        maxLength: maxLength);
  }
}

class TextState extends State<TextInput> {
  final String hint;
  final TextEditingController controller;
  final obscure;
  var _obscureMask = false;
  final int maxLength;

  TextState(
      {this.hint = "", this.controller, this.obscure = false, this.maxLength});

  @override
  Widget build(BuildContext context) {
    return new Container(
        decoration: new BoxDecoration(
            color: const Color(0x667D8388),
            borderRadius: new BorderRadius.all(new Radius.circular(4.0))),
        height: 48.0,
        padding: new EdgeInsets.all(8.0),
        margin: new EdgeInsets.fromLTRB(48.0, 8.0, 48.0, 8.0),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: controller,
                obscureText: obscure ? !_obscureMask : false,
                style: hintTextStyle.copyWith(
                    decoration: TextDecoration.none,
                    fontSize: 22.0,
                    color: Colors.black),
                textAlign: TextAlign.left,
                maxLength: maxLength,
                decoration: new InputDecoration.collapsed(
                  hintText: hint,
                  hintStyle: hintTextStyle.copyWith(fontSize: 22.0),
                ),
              ),
            ),
            obscure
                ? new GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureMask = !_obscureMask;
                      });
                    },
                    child: Container(
                      height: 48.0,
                      width: 48.0,
                      child: Icon(_obscureMask
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  )
                : new Container(
                    width: 0.0,
                    height: 0.0,
                  ),
          ],
        ));
  }
}

class JunButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;

  // ignore: conflicting_dart_import
  final TextStyle textStyle;

  JunButton(this.callback, this.text, { Key key,this.textStyle = baseTextStyle}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.fromLTRB(64.0, 8.0, 64.0, 8.0),
      child: new MaterialButton(
        splashColor: Colors.amberAccent,
        onPressed: callback,
        child: new Text(
          text,
          style: textStyle,
        ),
        color: callback==null?Colors.grey:gold,
      ),
    );
  }
}

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;

  GradientAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return new Container(
      color: gold[500],
      height: 54.0 + statusBarHeight,
      padding: new EdgeInsets.only(top: statusBarHeight),
      child: new DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            new BoxShadow(color: Colors.black26,offset: Offset(0.0, 5.0),blurRadius: 5.0,spreadRadius: 0.0)
          ],
          gradient: new LinearGradient(
              colors: [
                gold[500],
                gold[700],
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: new Stack(
          alignment: AlignmentDirectional.centerStart,
//          crossAxisAlignment: CrossAxisAlignment.center,
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
//            new Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: new Icon(Icons.keyboard_arrow_left),
//              ),
            Center(
              child: new Text(
                title,
                textAlign: TextAlign.center,
                style: baseTextStyle.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 22.0),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new Icon(Icons.keyboard_arrow_left),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class TransparentAppBar extends StatelessWidget {
  final String name;

  TransparentAppBar(this.name);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: new BackButton(color: Colors.white),
    );
  }
}
