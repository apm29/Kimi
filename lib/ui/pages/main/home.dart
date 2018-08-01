import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_office/images.dart';
import 'package:flutter_office/main.dart';
import 'package:flutter_office/model/api.dart';
import 'package:flutter_office/model/model.dart';
import 'package:flutter_office/text_style.dart';
import 'package:flutter_office/ui/pages/info/applicant.dart';
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
        }).then((baseResp) {
      if (baseResp != null) Fluttertoast.showToast(msg: baseResp.msg);
      if (baseResp.isSuccess()) {
        _doEditApplicant();
      }
    });
  }

  void _doEditApplicant() {
    Navigator.of(context).push(new PageRouteBuilder(pageBuilder: (a,b,c){
      return new ApplicantPage();
    }));
  }
}

class NewApplicantDialog extends StatefulWidget {
  @override
  State createState() {
    return new NewApplicantState();
  }
}

class NewApplicantState extends State<NewApplicantDialog> {
  var _idController = new TextEditingController(text:"330681199112151718");
  var _nameController = new TextEditingController(text: "该隐");
  CancelToken cancelToken = new CancelToken();

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
        child: new ListView(
          shrinkWrap: true,
//          mainAxisSize: MainAxisSize.min,
//          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new TextField(
              maxLength: 8,
              textAlign: TextAlign.end,
              decoration: new InputDecoration(
                labelText: "用户姓名",
                helperText: "姓名为2~4个汉字",
                isDense: true,
                filled: true,
              ),
              controller: _nameController,
            ),
            new TextField(
              textAlign: TextAlign.end,
              maxLength: 18,
              decoration: new InputDecoration(
                labelText: "用户身份证",
                helperText: "身份证号码为18位",
                isDense: true,
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
                      var map = {"msg": "取消", "code": 400};
                      var resp = new BaseResp.fromMap(map);
                      Navigator.of(context).pop<BaseResp>(resp);
                    },
                    child: new Text("取消")),
                new MaterialButton(
                  onPressed: _submitApplicant,
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

  void _submitApplicant() async {
    var name = _nameController.text;
    var idCard = _idController.text;
    if (name.isEmpty || idCard.isEmpty) {
      Fluttertoast.showToast(msg: "身份证/姓名不可为空");
      return;
    }
    var response = await can(context, cancelToken, name, idCard);
    print(response.data);
    var baseResp = new BaseResp(response.data);
    Navigator.of(context).pop<BaseResp>(baseResp);
  }
}
