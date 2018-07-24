import 'package:flutter/material.dart';
import 'package:flutter_office/images.dart';
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
      Fluttertoast.showToast(msg: success.msg);
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
  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(color: Colors.white),
      child: new IntrinsicWidth(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children:<Widget>[
            new Text("1"),
            new Text("2"),
            new Text("3"),
            new Text("4"),
            new Text("5"),
            new JunButton(() {
              var resp = new BaseResp('{"msg": "成功", "code": 200}');
              Navigator.of(context).pop<BaseResp>(resp);
            }, "提交"),

          ],
        ),
      ),
    );
  }
}
