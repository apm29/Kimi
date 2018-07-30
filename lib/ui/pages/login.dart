import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_office/images.dart';
import 'package:flutter_office/main.dart';
import 'package:flutter_office/model/api.dart';
import 'package:flutter_office/model/model.dart';
import 'package:flutter_office/text_style.dart';
import 'package:flutter_office/ui/pages/main.dart';
import 'package:flutter_office/ui/widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginState();
  }
}

class LoginState extends State<LoginPage> {
  var _nameController = new TextEditingController();
  var _passController = new TextEditingController();
  var _checked = true;

  CancelToken cancelToken = new CancelToken();

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context);
    var statusBarHeight = queryData.padding.top;
    return new Scaffold(
      body: new Container(
        constraints: new BoxConstraints.expand(),
        padding: new EdgeInsets.only(top: statusBarHeight),
        child: new ListView(
          children: <Widget>[
            new Container(
              height: 32.0,
            ),
            new Image.asset(
              launcher,
              width: 72.0,
              height: 72.0,
            ),
            new Container(
              height: 16.0,
            ),
            new Text(
              "君磊助手工作端",
              style: headerTitleStyle,
              textAlign: TextAlign.center,
            ),
            new Container(
              height: 32.0,
            ),
            new Container(
              alignment: Alignment.center,
              child: new TextInput(
                hint: "请输入用户名",
                controller: _nameController,
              ),
            ),
            new Container(
              height: 8.0,
            ),
            new Container(
              alignment: Alignment.center,
              child: new TextInput(
                controller: _passController,
                hint: "请输入密码",
                obscure: true,
              ),
            ),
            new Container(
              height: 24.0,
            ),
            new JunButton(_login,"登录"),
            new Container(
              height: 32.0,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Checkbox(
                    value: _checked,
                    onChanged: (bool) {
                      setState(() {
                        _checked = bool;
                      });
                    }),
                new Text(
                  "登录即视为同意",
                  style: baseTextStyle.copyWith(color: Colors.black54),
                ),
                new GestureDetector(
                  child: new Text(
                    "<<君磊助手服务协议>>",
                    style: baseTextStyle,
                  ),
                  onTap: _toService,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _toService() {
    //todo
  }

  _login() {
    if (_checkState()) {
      performLogin();
    }
  }

  bool _checkState() {
    print("click");
    if (!_checked) {
      Fluttertoast.showToast(
        msg: "请同意用户协议",
      );
    } else if (_nameController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "请填写用户名",
      );
    } else if (_passController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "请填写密码",
      );
    }
    return _checked &&
        _nameController.text.isNotEmpty &&
        _passController.text.isNotEmpty;
  }

  void performLogin() {
    login(context,cancelToken, _nameController.text.trim(), _passController.text.trim())
        .then((resp) async {
      var baseResp = BaseResp<Login>(resp.data);
      if (baseResp.isSuccess()) {
        prefs
            .setString('access_token', baseResp.data.access_token)
            .then((success) {
          toMain();
        });
      }
      Fluttertoast.showToast(msg: baseResp.msg);
    });
  }

  @override
  void dispose() {
    cancelToken.cancel("取消");
    super.dispose();
  }

  void toMain() {
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (context) {
      return new MainPage();
    }));
  }
}
