import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_office/const.dart';
import 'package:flutter_office/main.dart';
import 'package:flutter_office/model/api.dart';
import 'package:flutter_office/model/model.dart';
import 'package:flutter_office/text_style.dart';
import 'package:flutter_office/ui/widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

enum InputType { TEXT, SELECT, CHECK }

class ApplicantPersonalInfoPage extends StatefulWidget {
  final int applicationId;

  @override
  State<StatefulWidget> createState() {
    return new PersonalInfoState(applicationId);
  }

  ApplicantPersonalInfoPage(this.applicationId);
}

class SliverUiRule {
  String title;
  String hint;
  InputType type;
  bool imperative;
  TextEditingController controller;
  String suffix;
  TransformRule rule;
  TextStyle style;
  String field;
  bool visible;
  bool isEditable = true;

  SliverUiRule(this.field, this.title, this.hint, this.type, this.imperative,
      this.controller, this.suffix, this.rule,
      {this.style, this.visible = true, this.isEditable});
}

abstract class TransformRule<T> {
  Map<String, T> map;

  String getString(T value);

  T getValue(String text);
}

class S2STransformRule extends TransformRule<String> {
  S2STransformRule();

  @override
  String getString(dynamic value) {
    return value.toString();
  }

  @override
  String getValue(String text) {
    return text;
  }
}

class GenderRule extends TransformRule<int> {
  Map<String, int> map = {
    "男": 1,
    "女": 2,
  };

  @override
  String getString(int value) {
    for (String key in map.keys) {
      if (map[key] == value) {
        return key;
      }
    }
    return null;
  }

  @override
  int getValue(String text) {
    return map[text];
  }
}

class MarriageRule extends TransformRule<int> {
  Map<String, int> map = {
    "已婚": 1,
    "离婚": 2,
    "丧偶": 3,
    "未婚": 0,
  };

  @override
  String getString(int value) {
    for (String key in map.keys) {
      if (map[key] == value) {
        return key;
      }
    }
    return null;
  }

  @override
  int getValue(String text) {
    return map[text];
  }
}

class StaffingRule extends TransformRule<int> {
  Map<String, int> map = {
    "事业": 0,
    "企业": 1,
    "公务员": 2,
  };

  @override
  String getString(int value) {
    for (String key in map.keys) {
      if (map[key] == value) {
        return key;
      }
    }
    return null;
  }

  @override
  int getValue(String text) {
    return map[text];
  }
}

class RepaymentTypeRule extends TransformRule<int> {
  Map<String, int> map = {
    "先息后本": 0,
    "等额本息": 1,
  };

  @override
  String getString(int value) {
    for (String key in map.keys) {
      if (map[key] == value) {
        return key;
      }
    }
    return null;
  }

  @override
  int getValue(String text) {
    return map[text];
  }
}

class PersonalInfoState extends State<ApplicantPersonalInfoPage> {
  final int applicationId;
  Map<String, SliverUiRule> ruleUi = <String, SliverUiRule>{
    "real_name": new SliverUiRule("real_name", "姓名", "请输入姓名", InputType.TEXT,
        true, new TextEditingController(), null, new S2STransformRule()),
    "id_card_no": new SliverUiRule(
        "id_card_no",
        "身份证",
        "请输入身份证",
        InputType.TEXT,
        true,
        new TextEditingController(),
        null,
        new S2STransformRule()),
    "gender": new SliverUiRule("gender", "性别", "请选择性别", InputType.SELECT, true,
        new TextEditingController(), null, new GenderRule()),
    "marital_status": new SliverUiRule(
        "marital_status",
        "婚姻状况",
        "请选择婚姻状况",
        InputType.SELECT,
        true,
        new TextEditingController(),
        null,
        new MarriageRule()),
    "couple_real_name": new SliverUiRule(
        "couple_real_name",
        "配偶姓名",
        "请输入配偶姓名",
        InputType.TEXT,
        true,
        new TextEditingController(),
        null,
        new S2STransformRule()),
    "couple_id_card_no": new SliverUiRule(
        "couple_id_card_no",
        "配偶身份证",
        "请输入配偶身份证",
        InputType.TEXT,
        true,
        new TextEditingController(),
        null,
        new S2STransformRule()),
    "company_name": new SliverUiRule(
        "company_name",
        "工作单位(全称)",
        "请输入工作单位(全称)",
        InputType.TEXT,
        true,
        new TextEditingController(),
        null,
        new S2STransformRule()),
    "department": new SliverUiRule(
        "department",
        "所在部门",
        "请输入所在部门",
        InputType.TEXT,
        true,
        new TextEditingController(),
        null,
        new S2STransformRule()),
    "position_level": new SliverUiRule(
        "position_level",
        "职务",
        "请输入职务",
        InputType.TEXT,
        true,
        new TextEditingController(),
        null,
        new S2STransformRule()),
    "staffing": new SliverUiRule("staffing", "编制", "请选择编制", InputType.SELECT,
        true, new TextEditingController(), null, new StaffingRule()),
    "year_income": new SliverUiRule(
        "year_income",
        "年收入",
        "请输入年收入",
        InputType.TEXT,
        true,
        new TextEditingController(),
        "万元",
        new S2STransformRule()),
    "foundation_month_amount": new SliverUiRule(
        "foundation_month_amount",
        "公积金月缴额",
        "请输入公积金月缴额",
        InputType.TEXT,
        true,
        new TextEditingController(),
        "元",
        new S2STransformRule()),
    "repayment_type": new SliverUiRule(
        "repayment_type",
        "还款方式",
        "请选择还款方式",
        InputType.SELECT,
        true,
        new TextEditingController(),
        null,
        new RepaymentTypeRule()),
    "term": new SliverUiRule("term", "期限", "请输入期限", InputType.TEXT, true,
        new TextEditingController(), "月", new S2STransformRule()),
    "credit_account": new SliverUiRule(
        "credit_account",
        "征信账号",
        "请输入征信账号",
        InputType.TEXT,
        true,
        new TextEditingController(),
        null,
        new S2STransformRule()),
    "credit_account_password": new SliverUiRule(
        "credit_account_password",
        "征信密码",
        "请输入征信密码",
        InputType.TEXT,
        true,
        new TextEditingController(),
        null,
        new S2STransformRule()),
    "credit_account_code": new SliverUiRule(
        "credit_account_code",
        "征信验证码",
        "请输入征信验证码",
        InputType.TEXT,
        true,
        new TextEditingController(),
        null,
        new S2STransformRule()),
    "foundation_account": new SliverUiRule(
        "foundation_account",
        "公积金账号",
        "请输入公积金账号",
        InputType.TEXT,
        true,
        new TextEditingController(),
        null,
        new S2STransformRule()),
    "foundation_account_password": new SliverUiRule(
        "foundation_account_password",
        "公积金密码",
        "请输入公积金密码",
        InputType.TEXT,
        true,
        new TextEditingController(),
        null,
        new S2STransformRule()),
    "gov_affairs_account": new SliverUiRule(
        "gov_affairs_account",
        "政务网账号",
        "请输入政务网账号",
        InputType.TEXT,
        false,
        new TextEditingController(),
        null,
        new S2STransformRule()),
    "gov_affairs_account_password": new SliverUiRule(
        "gov_affairs_account_password",
        "政务网密码",
        "请输入政务网密码",
        InputType.TEXT,
        false,
        new TextEditingController(),
        null,
        new S2STransformRule()),
  };

  PersonalInfoState(this.applicationId) {
    initData();
  }

  void initData() async {
    var applicantString;
    var instance = await SharedPreferences.getInstance();
    if (applicationId == 0) {
      //新进件
      applicantString = instance.getString(applicant_local);
    } else {
      //旧进件
      applicantString = instance.getString("$applicant_local$applicationId");
      if (applicantString == null) {
        var resp = await info(context, new CancelToken(), applicationId);
        applicantString = new BaseResp(resp.data).data;
      }
    }

    _initTextController(applicantString);
  }

  Map<String, dynamic> applicant;

  void _initTextController(dynamic applicantString) {
    setState(() {
      if (applicantString is String)
        applicant = json.decode(applicantString);
      else
        applicant = applicantString;

      for (String key in applicant["profile"].keys) {
        if (ruleUi.containsKey(key)) {
          TransformRule transRule = ruleUi[key].rule;
          var string = transRule.getString(applicant["profile"][key]);
          ruleUi[key].controller.text = string == "null" ? "" : string;
        }
      }
      for (String key in applicant["job"].keys) {
        if (ruleUi.containsKey(key)) {
          TransformRule transRule = ruleUi[key].rule;
          var string = transRule.getString(applicant["job"][key]);
          ruleUi[key].controller.text = string == "null" ? "" : string;
        }
      }
      //是否已婚
      ruleUi["couple_real_name"].visible = applicant["marital_status"] == 1;
      ruleUi["couple_id_card_no"].visible = applicant["marital_status"] == 1;

      //是否可编辑
      if (applicant['is_editable'] == false) {
        for (String key in applicant['job'].keys) {
          if (ruleUi.containsKey(key)) ruleUi[key].isEditable = false;
        }
        for (String key in applicant['profile'].keys) {
          if (ruleUi.containsKey(key)) ruleUi[key].isEditable = false;
        }
      } else if (applicant['is_editable'] == true && applicationId != 0) {
        for (String key in applicant['job'].keys) {
          if (ruleUi.containsKey(key))
            ruleUi[key].isEditable =
                applicant['job']['allow_field'].toString().contains(key);
        }
        for (String key in applicant['profile'].keys) {
          if (ruleUi.containsKey(key))
            ruleUi[key].isEditable =
                applicant['profile']['allow_field'].toString().contains(key);
        }
      } else if (applicant['is_editable'] == true && applicationId == 0) {
        for (String key in applicant['job'].keys) {
          if (ruleUi.containsKey(key)) ruleUi[key].isEditable = true;
        }
        for (String key in applicant['profile'].keys) {
          if (ruleUi.containsKey(key)) ruleUi[key].isEditable = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new GradientAppBar("申请人信息"),
          Expanded(
            child: new ListView.builder(
              padding: new EdgeInsets.all(0.0),
              itemBuilder: (_, index) {
                if (index == ruleUi.length) return buildSubmitButton();
                var key = ruleUi.keys.toList()[index];
                return _buildRowSliver(
                    ruleUi[key].title,
                    ruleUi[key].hint,
                    ruleUi[key].type,
                    ruleUi[key]?.imperative ?? true,
                    ruleUi[key].controller,
                    ruleUi[key].isEditable ?? true, () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return new PickerWidget(
                            ruleUi[key].title, ruleUi[key].rule.map);
                      }).then((res) {
                    if (res != null) {
                      Fluttertoast.showToast(msg: res.toString());
                      setState(() {
                        var uiRule = ruleUi[key];
                        uiRule.controller.text = res;

                        ///其他特异规则
                        //是否已婚
                        var marriageRule = ruleUi["marital_status"].rule;
                        if (marriageRule.map.containsKey(res)) {
                          ruleUi["couple_real_name"].visible =
                              marriageRule.getValue(res) == 1;
                          ruleUi["couple_id_card_no"].visible =
                              marriageRule.getValue(res) == 1;
                        }
                      });
                    }
                  });
                }, ruleUi[key].suffix, ruleUi[key].visible??true);
              },
              itemCount: ruleUi.length + 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSubmitButton() => new JunButton(
      applicant != null && applicant['is_editable'] == true ? doSubmit : null,
      "保存");

  void doSubmit() {

  }

  Widget _buildRowSliver(String title, String hint, InputType type,
      bool imperative, TextEditingController controller, bool isEditable,
      [VoidCallback onPress, String suffix, bool visible = true]) {
    if (!visible) {
      return new Container(
        height: 0.0,
      );
    }
    return Column(
      children: <Widget>[
        new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: new Row(
                children: <Widget>[
                  Text.rich(new TextSpan(children: <TextSpan>[
                    new TextSpan(
                        text: imperative ? "*" : " ",
                        style: hintTextStyle.copyWith(
                            color: Colors.red, fontSize: 16.0)),
                    new TextSpan(
                        text: title,
                        style: baseTextStyle.copyWith(fontSize: 18.0)),
                  ])),
                ],
              ),
            ),
            Expanded(
                child: GestureDetector(
              onTap: type == InputType.SELECT && isEditable ? onPress : null,
              child: type == InputType.TEXT
                  ? TextField(
                      controller: controller,
                      enabled: isEditable,
                      style: baseTextStyle.copyWith(
                          color: isEditable ? Colors.black : Colors.black38),
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: type == InputType.SELECT
                              ? new Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: new Icon(Icons.keyboard_arrow_down),
                                )
                              : null,
                          hintText: hint,
                          fillColor: Colors.grey),
                    )
                  : new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Text(
                            controller.text.isEmpty ? hint : controller.text,
                            style: baseTextStyle.copyWith(
                                color:
                                    isEditable ? Colors.black : Colors.black38),
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.all(8.0),
                          child: new Icon(Icons.keyboard_arrow_down),
                        )
                      ],
                    ),
            )),
            suffix != null
                ? new Padding(
                    padding: EdgeInsets.all(8.0),
                    child: new Text(suffix),
                  )
                : new Container()
          ],
        ),
        _buildSeparatorSliver()
      ],
    );
  }

  Widget _buildSeparatorSliver() {
    return new Container(
      color: Colors.black12,
      height: 0.5,
    );
  }
}

class PickerWidget<T> extends StatelessWidget {
  final String title;
  final Map<String, T> map;

  PickerWidget(this.title, this.map);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: new Column(
        children: <Widget>[
          new Expanded(
              child: GestureDetector(
                  child: new Container(
            constraints: BoxConstraints.expand(),
          ))),
          new Container(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                  color: gold[500],
                  boxShadow: [
                    new BoxShadow(
                        color: Colors.black26,
                        offset: Offset(5.0, 0.0),
                        blurRadius: 5.0,
                        spreadRadius: 5.0)
                  ],
                  borderRadius: new BorderRadiusDirectional.only(
                      topEnd: new Radius.circular(8.0),
                      topStart: new Radius.circular(8.0))),
              child: Center(
                child: new Text(
                  "请选择$title",
                  style: baseTextStyle.copyWith(
                      fontSize: 20.0, color: Colors.white),
                ),
              )),
          new Container(
            color: Colors.black12,
            height: 0.5,
          ),
          new Container(
            decoration: BoxDecoration(
                color: Colors.white,
                gradient: new LinearGradient(
                    colors: [gold[100], Colors.white70],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            constraints: BoxConstraints.loose(new Size.fromHeight(260.0)),
            child: new ListView.builder(
              physics:
                  new BouncingScrollPhysics(parent: new PageScrollPhysics()),
              itemBuilder: (context, index) {
                return new GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(map.keys.toList()[index]);
                  },
                  child: new Container(
//                    transform:
//                        new Matrix4.rotationZ(0.06 * (index.isEven ? -1 : 1))
//                          ..add(new Matrix4.translationValues(
//                              0.0, 10.0 * (index.isOdd ? -1 : 1), 0.0))
//                    ..add(new Matrix4.diagonal3(vector.Vector3.all(1.3))),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(0.0),
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0, -1.0),
                          blurRadius: 1.0,
                        )
                      ],
                    ),
                    constraints:
                        BoxConstraints.loose(new Size.fromHeight(80.0)),
                    padding: EdgeInsets.all(16.0),
                    alignment: AlignmentDirectional.center,
                    child: new Text(
                      map.keys.toList()[index],
                      style: baseTextStyle.copyWith(fontSize: 18.0),
                    ),
                  ),
                );
              },
              itemCount: map.length,
              shrinkWrap: true,
            ),
          )
        ],
      ),
    );
  }
}
