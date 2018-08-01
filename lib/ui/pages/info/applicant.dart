import 'package:flutter/material.dart';
import 'package:flutter_office/main.dart';
import 'package:flutter_office/text_style.dart';
import 'package:flutter_office/ui/widget.dart';

typedef void PressSliver(BuildContext context);

class ApplicantPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          new GradientAppBar("进件人信息"),
          new Expanded(
            child: new Column(
              children: <Widget>[
                _buildInfoSliver(context, "申请人信息", _toPersonalInfo, false),
                _buildSeparatorSliver(),
                _buildInfoSliver(context, "家庭财产", _toPersonalInfo, false),
                _buildSeparatorSliver(),
                Expanded(
                    child: Container(
                  alignment: AlignmentDirectional.center,
                  padding: EdgeInsets.symmetric(horizontal: 64.0),
                  child: new MaterialButton(
                    minWidth: 200.0,
                    onPressed: () {},
                    color: gold,
                    splashColor: Colors.amberAccent,
                    child: new Text("提交",style: headerTitleStyle,),
                  ),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _buildSeparatorSliver() {
    return new Container(
      color: Colors.black12,
      height: 1.0,
    );
  }

  Widget _buildInfoSliver(
      BuildContext context, String text, PressSliver call, bool filled) {
    return GestureDetector(
      onTap: () {
        call(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
                child: new Text(
              text,
              style: baseTextStyle.copyWith(fontSize: 20.0),
            )),
            new Text(
              filled ? "已填写" : "未填写",
              style: hintTextStyle,
            ),
            new Icon(Icons.keyboard_arrow_right)
          ],
        ),
      ),
    );
  }

  void _toPersonalInfo(BuildContext context) {}
}
