import 'package:flutter/material.dart';
import 'package:flutter_office/images.dart';
import 'package:flutter_office/main.dart';
import 'package:flutter_office/model/model.dart';
import 'package:flutter_office/text_style.dart';
import 'package:flutter_office/ui/widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeState();
  }
}

class HomeState extends State<HomeFragment> {
  final keyA = new Key("A");

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new ListView(
        padding: new EdgeInsets.all(0.0),
        children: <Widget>[
          new Image.asset(
            banner_static,
            fit: BoxFit.cover,
          ),
          new Container(
            height: 48.0,
          ),
          new Image.asset(
            no_credit_info,
            height: 128.0,
            width: 128.0,
          ),
          new Container(
            height: 48.0,
          ),
          new JunButton(
            _applicantInfo,
            "快速进件",
            textStyle: buttonTextStyle,
          ),
        ],
      ),
    );
  }

  void _applicantInfo() {
    showDialog<BaseResp>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return new NewApplicantDialog();
        }).then((success) {
      if (success != null) Fluttertoast.showToast(msg: success.msg);
    });
  }
}

class NewApplicantDialog extends StatefulWidget {
  @override
  State createState() {
    return new NewApplicantState();
  }
}

class NewApplicantState extends State<NewApplicantDialog> {
  var _idController = new TextEditingController();
  var _nameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Center(
          child: new Text(
        "进件客户验证",
        style: hintTextStyle.copyWith(fontSize: 16.0),
      )),
      content: new Container(
        width: MediaQuery.of(context).size.width,
        margin: new EdgeInsets.symmetric(horizontal: 16.0),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new TextField(
              textAlign: TextAlign.end,
              decoration: new InputDecoration(
                labelText: "用户姓名",
                helperText: "姓名为2~4个汉字",
                isDense: true,
                prefixText: "用户姓名",
                filled: true,
              ),
              controller: _nameController,

            ),
            new TextField(
              textAlign: TextAlign.end,
              decoration: new InputDecoration(
                labelText: "用户身份证",
                helperText: "身份证号码为18位",
                isDense: true,
                prefixText: "用户身份证",
                filled: true,
              ),
              controller: _idController,
            ),
            new Container(
              height: 12.0,
            ),
            new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new MaterialButton(
                    onPressed: () {
                      var resp = new BaseResp('{"msg": "取消", "code": 200}');
                      Navigator.of(context).pop<BaseResp>(resp);
                    },
                    child: new Text("取消")),
                new MaterialButton(
                  onPressed: () {
                    var resp = new BaseResp('{"msg": "成功", "code": 200}');
                    Navigator.of(context).pop<BaseResp>(resp);
                  },
                  color: gold,
                  splashColor: Colors.amberAccent,
                  child: new Text("提交"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
