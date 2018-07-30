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
                obscureText: obscure?!_obscureMask:false,
                style: hintTextStyle.copyWith(
                    decoration: TextDecoration.none,
                    fontSize: 22.0,
                    color: Colors.black),
                textAlign: TextAlign.left,
                maxLength: maxLength,
                decoration: new InputDecoration.collapsed(
                  hintText: hint,
                  hintStyle: hintTextStyle,
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
  final TextStyle textStyle;
  JunButton(this.callback,this.text,{this.textStyle = baseTextStyle});

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
        color: gold,
      ),
    );
  }
}
