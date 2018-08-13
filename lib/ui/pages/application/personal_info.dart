import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_office/const.dart';
import 'package:flutter_office/main.dart';
import 'package:flutter_office/model/api.dart';
import 'package:flutter_office/model/model.dart';
import 'package:flutter_office/text_style.dart';
import 'package:flutter_office/ui/widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isEditable;

  int maxLength;
  TextInputType keyboardType;
  RegExp regExp;

  SliverUiRule(this.field, this.title, this.hint,
      {this.type = InputType.TEXT,
      this.rule,
      this.suffix,
      this.controller,
      this.style,
      this.imperative = true,
      this.visible = true,
      this.isEditable = true,
      this.maxLength = 200,
      this.regExp,
      this.keyboardType = TextInputType.text}) {
    if (controller == null) controller = new TextEditingController();
    if (rule == null) rule = new S2STransformRule();
    if (regExp == null) regExp = new RegExp(r"[\s\S]*");
  }
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
  Map<String, SliverUiRule> uiRules = <String, SliverUiRule>{
    "real_name": new SliverUiRule("real_name", "姓名", "请输入姓名", maxLength: 4),
    "id_card_no": new SliverUiRule("id_card_no", "身份证", "请输入身份证",
        maxLength: 18, regExp: new RegExp("[0-9xX]")),
    "gender": new SliverUiRule(
      "gender",
      "性别",
      "请选择性别",
      rule: new GenderRule(),
      type: InputType.SELECT,
    ),
    "marital_status": new SliverUiRule(
      "marital_status",
      "婚姻状况",
      "请选择婚姻状况",
      rule: new MarriageRule(),
      type: InputType.SELECT,
    ),
    "couple_real_name":
        new SliverUiRule("couple_real_name", "配偶姓名", "请输入配偶姓名", maxLength: 4),
    "couple_id_card_no": new SliverUiRule(
        "couple_id_card_no", "配偶身份证", "请输入配偶身份证",
        maxLength: 18),
    "company_name": new SliverUiRule("company_name", "工作单位(全称)", "请输入工作单位(全称)"),
    "department": new SliverUiRule("department", "所在部门", "请输入所在部门"),
    "position_level": new SliverUiRule("position_level", "职务", "请输入职务"),
    "staffing": new SliverUiRule("staffing", "编制", "请选择编制",
        rule: new StaffingRule(), type: InputType.SELECT),
    "year_income": new SliverUiRule("year_income", "年收入", "请输入年收入",
        regExp: new RegExp(r"[0-9.]"),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        suffix: "万元"),
    "foundation_month_amount": new SliverUiRule(
        "foundation_month_amount", "公积金月缴额", "请输入公积金月缴额",
        suffix: "元",
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        regExp: new RegExp(r"[0-9.]")),
    "repayment_type": new SliverUiRule(
      "repayment_type",
      "还款方式",
      "请选择还款方式",
      rule: new RepaymentTypeRule(),
      type: InputType.SELECT,
    ),
    "term": new SliverUiRule("term", "期限", "请输入期限",
        suffix: "月", regExp: new RegExp(r"[0-9]")),
    "credit_account": new SliverUiRule("credit_account", "征信账号", "请输入征信账号"),
    "credit_account_password":
        new SliverUiRule("credit_account_password", "征信密码", "请输入征信密码"),
    "credit_account_code": new SliverUiRule(
        "credit_account_code", "征信验证码", "请输入征信验证码",
        maxLength: 6),
    "foundation_account":
        new SliverUiRule("foundation_account", "公积金账号", "请输入公积金账号"),
    "foundation_account_password":
        new SliverUiRule("foundation_account_password", "公积金密码", "请输入公积金密码"),
    "gov_affairs_account": new SliverUiRule(
        "gov_affairs_account", "政务网账号", "请输入政务网账号",
        imperative: false),
    "gov_affairs_account_password": new SliverUiRule(
        "gov_affairs_account_password", "政务网密码", "请输入政务网密码",
        imperative: false),
  };

  PersonalInfoState(this.applicationId) {
    initData();
  }

  void initData() async {
    var applicantString;
    var instance = await SharedPreferences.getInstance();
    if (applicationId == 0) {
      //新进件
      applicantString = instance.getString("$applicant_local$applicationId");
    } else {
      //旧进件
      applicantString = instance.getString("$applicant_local$applicationId");
      if (applicantString == null) {
        var resp = await info(context, new CancelToken(), applicationId);
        applicantString = new BaseResp(resp.data).data;
      }
    }

    _initTextController(applicantString);
    print(applicantString);
  }

  Map<String, dynamic> applicant;

  void _initTextController(dynamic applicantString) {
    setState(() {
      if (applicantString is String)
        applicant = json.decode(applicantString);
      else
        applicant = applicantString;

      for (String key in applicant["profile"].keys) {
        if (uiRules.containsKey(key)) {
          TransformRule transRule = uiRules[key].rule;
          var string = transRule.getString(applicant["profile"][key]);
          uiRules[key].controller.text = string == "null" ? "" : string;
        }
      }
      for (String key in applicant["job"].keys) {
        if (uiRules.containsKey(key)) {
          TransformRule transRule = uiRules[key].rule;
          var string = transRule.getString(applicant["job"][key]);
          uiRules[key].controller.text = string == "null" ? "" : string;
        }
      }
      //是否已婚
      uiRules["couple_real_name"].visible = applicant["marital_status"] == 1;
      uiRules["couple_id_card_no"].visible = applicant["marital_status"] == 1;

      //是否可编辑
      if (applicant['is_editable'] == false) {
        for (String key in applicant['job'].keys) {
          if (uiRules.containsKey(key)) uiRules[key].isEditable = false;
        }
        for (String key in applicant['profile'].keys) {
          if (uiRules.containsKey(key)) uiRules[key].isEditable = false;
        }
      } else if (applicant['is_editable'] == true && applicationId != 0) {
        for (String key in applicant['job'].keys) {
          if (uiRules.containsKey(key))
            uiRules[key].isEditable =
                applicant['job']['allow_field'].toString().contains(key);
        }
        for (String key in applicant['profile'].keys) {
          if (uiRules.containsKey(key))
            uiRules[key].isEditable =
                applicant['profile']['allow_field'].toString().contains(key);
        }
      } else if (applicant['is_editable'] == true && applicationId == 0) {
        for (String key in applicant['job'].keys) {
          if (uiRules.containsKey(key)) uiRules[key].isEditable = true;
        }
        for (String key in applicant['profile'].keys) {
          if (uiRules.containsKey(key)) uiRules[key].isEditable = true;
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
                if (index == uiRules.length) return buildSubmitButton();
                var key = uiRules.keys.toList()[index];
                return _buildRowSliver(uiRules[key], () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return new PickerWidget(
                            uiRules[key].title, uiRules[key].rule.map);
                      }).then((res) {
                    if (res != null) {
                      Fluttertoast.showToast(msg: res.toString());
                      setState(() {
                        var uiRule = uiRules[key];
                        uiRule.controller.text = res;

                        ///其他特异规则
                        //是否已婚
                        var marriageRule = uiRules["marital_status"].rule;
                        if (marriageRule.map.containsKey(res)) {
                          uiRules["couple_real_name"].visible =
                              marriageRule.getValue(res) == 1;
                          uiRules["couple_id_card_no"].visible =
                              marriageRule.getValue(res) == 1;
                        }
                      });
                    }
                  });
                }, uiRules[key].suffix, uiRules[key].visible ?? true);
              },
              itemCount: uiRules.length + 1,
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
    uiRules.forEach((k,v){
      if(applicant['profile'].containsKey(k)){
        applicant['profile'][k] = v.rule.getValue(v.controller.text);
      }
      if(applicant['job'].containsKey(k)){
        applicant['job'][k] = v.rule.getValue(v.controller.text);
      }
    });
    SharedPreferences.getInstance().then((sp){
      print(applicant);
      sp.setString('$applicant_local$applicationId', Applicant(applicant).toString());
      Navigator.pop(context);
    });
  }

  Widget _buildRowSliver(SliverUiRule rule,
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
                        text: rule.imperative == true ? "*" : " ",
                        style: hintTextStyle.copyWith(
                            color: Colors.red, fontSize: 16.0)),
                    new TextSpan(
                        text: rule.title,
                        style: baseTextStyle.copyWith(fontSize: 18.0)),
                  ])),
                ],
              ),
            ),
            Expanded(
                child: GestureDetector(
              onTap: rule.type == InputType.SELECT && rule.isEditable
                  ? onPress
                  : null,
              child: rule.type == InputType.TEXT
                  ? TextField(
                      inputFormatters: <TextInputFormatter>[
                        new WhitelistingTextInputFormatter(rule.regExp),
                      ],
                      onChanged: (v) {
                        if (v.length > rule.maxLength) {
                          rule.controller.text = v.substring(0, rule.maxLength);
                          rule.controller.selection =
                              new TextSelection.fromPosition(
                                  new TextPosition(offset: rule.maxLength));
                        }
                      },
                      controller: rule.controller,
                      enabled: rule.isEditable,
                      keyboardType: rule.keyboardType,
                      style: baseTextStyle.copyWith(
                          color:
                              rule.isEditable ? Colors.black : Colors.black38),
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: rule.type == InputType.SELECT
                              ? new Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: new Icon(
                                    Icons.keyboard_arrow_down,
                                    color: rule.isEditable
                                        ? Colors.black
                                        : Colors.black38,
                                  ),
                                )
                              : null,
                          hintText: rule.hint,
                          fillColor: Colors.grey),
                    )
                  : new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Text(
                            rule.controller.text.isEmpty
                                ? rule.hint
                                : rule.controller.text,
                            style: baseTextStyle.copyWith(
                                color: rule.isEditable
                                    ? Colors.black
                                    : Colors.black38),
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
