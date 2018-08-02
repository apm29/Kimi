import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_office/const.dart';
import 'package:flutter_office/model/api.dart';
import 'package:flutter_office/model/model.dart';
import 'package:flutter_office/text_style.dart';
import 'package:flutter_office/ui/widget.dart';
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

class SliverUiRule{
  String title;
  String hint;
  InputType type;
  bool imperative;
  TextEditingController controller;
  String suffix;
  TransformRule rule;
  TextStyle style;

  String field;

  SliverUiRule(this.field,this.title , this.hint , this.type , this.imperative ,
      this.controller , this.suffix , this.rule,{this.style} );

}



abstract class TransformRule<T> {
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
    "未知": 0,
  };

  @override
  String getString(int value) {
    for(String key in map.keys){
      if(map[key]==value){
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
    for(String key in map.keys){
      if(map[key]==value){
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
    for(String key in map.keys){
      if(map[key]==value){
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
    for(String key in map.keys){
      if(map[key]==value){
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
  Map<String,SliverUiRule> ruleUi = <String,SliverUiRule>{
    "real_name"                   :new SliverUiRule("real_name",                       "姓名",        "请输入姓名",             InputType.TEXT,      true,       new TextEditingController(),      null,     new S2STransformRule()            ),
    "id_card_no"                  :new SliverUiRule("id_card_no",                      "身份证",       "请输入身份证",            InputType.TEXT,      true,       new TextEditingController(),      null,     new S2STransformRule()            ),
    "gender"                       :new SliverUiRule("gender",                          "性别",        "请选择性别",             InputType.SELECT,    true,       new TextEditingController(),      null,     new GenderRule()             ),
    "marital_status"               :new SliverUiRule("marital_status",                  "婚姻状况",      "请选择婚姻状况",           InputType.SELECT,    true,       new TextEditingController(),      null,     new MarriageRule()                 ),
    "couple_real_name"             :new SliverUiRule("couple_real_name",                "配偶姓名",      "请输入配偶姓名",           InputType.TEXT,      true,       new TextEditingController(),      null,     new S2STransformRule()                ),
    "couple_id_card_no"            :new SliverUiRule("couple_id_card_no",               "配偶身份证",     "请输入配偶身份证",          InputType.TEXT,      true,       new TextEditingController(),      null,     new S2STransformRule()                ),
    "company_name"                :new SliverUiRule("company_name",                    "工作单位(全称)",  "请输入工作单位(全称)",       InputType.TEXT,      true,       new TextEditingController(),      null,     new S2STransformRule()                        ),
    "department"                  :new SliverUiRule("department",                      "所在部门",      "请输入所在部门",           InputType.TEXT,      true,       new TextEditingController(),      null,     new S2STransformRule()                ),
    "position_level"               :new SliverUiRule("position_level",                  "职务",        "请输入职务",             InputType.TEXT,      true,       new TextEditingController(),      null,     new S2STransformRule()            ),
    "staffing"                    :new SliverUiRule("staffing",                        "编制",        "请选择编制",             InputType.SELECT,     true,      new TextEditingController(),      null,     new StaffingRule()             ),
    "year_income"                  :new SliverUiRule("year_income",                     "年收入",       "请输入年收入",            InputType.TEXT,      true,       new TextEditingController(),      "万元",     new S2STransformRule()            ),
    "foundation_month_amount"      :new SliverUiRule("foundation_month_amount",         "公积金月缴额",    "请输入公积金月缴额",         InputType.TEXT,      true,       new TextEditingController(),      "元",      new S2STransformRule()                    ),
    "repayment_type"              :new SliverUiRule("repayment_type",                  "还款方式",      "请选择还款方式",           InputType.SELECT,    true,       new TextEditingController(),      null,     new RepaymentTypeRule()                 ),
    "term"                        :new SliverUiRule("term",                            "期限",        "请输入期限",             InputType.TEXT,      true,       new TextEditingController(),      "月",      new S2STransformRule()            ),
    "credit_account"               :new SliverUiRule("credit_account",                  "征信账号",      "请输入征信账号",           InputType.TEXT,      true,       new TextEditingController(),      null,     new S2STransformRule()                ),
    "credit_account_password"     :new SliverUiRule("credit_account_password",         "征信密码",      "请输入征信密码",           InputType.TEXT,      true,       new TextEditingController(),      null,     new S2STransformRule()                ),
    "credit_account_code"          :new SliverUiRule("credit_account_code",             "征信验证码",     "请输入征信验证码",          InputType.TEXT,      true,       new TextEditingController(),      null,     new S2STransformRule()                ),
    "foundation_account"           :new SliverUiRule("foundation_account",              "公积金账号",     "请输入公积金账号",          InputType.TEXT,      true,       new TextEditingController(),      null,     new S2STransformRule()                ),
    "foundation_account_password"  :new SliverUiRule("foundation_account_password",     "公积金密码",     "请输入公积金密码",          InputType.TEXT,      true,       new TextEditingController(),      null,     new S2STransformRule()                ),
    "gov_affairs_account"         :new SliverUiRule("gov_affairs_account",             "政务网账号",     "请输入政务网账号",          InputType.TEXT,      false,      new TextEditingController(),      null,     new S2STransformRule()                ),
    "gov_affairs_account_password" :new SliverUiRule("gov_affairs_account_password",    "政务网密码",     "请输入政务网密码",          InputType.TEXT,      false,      new TextEditingController(),      null,     new S2STransformRule()                ),
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

  void _initTextController(dynamic applicantString) {
    setState(() {
      Map<String, dynamic> applicant;
      if (applicantString is String)
        applicant = json.decode(applicantString);
      else
        applicant = applicantString;

      for (String key in applicant["profile"].keys) {
        if (ruleUi.containsKey(key)) {
          TransformRule transRule = ruleUi[key].rule;
          ruleUi[key].controller.text =
              transRule.getString(applicant["profile"][key]).toString();
        }
      }
      for (String key in applicant["job"].keys) {
        if (ruleUi.containsKey(key)) {
          TransformRule transRule = ruleUi[key].rule;
          ruleUi[key].controller.text =
              transRule.getString(applicant["job"][key]).toString();
        }
      }

    });
  }

//  final List<String> title = <String>[
//    "姓名",
//    "身份证",
//    "性别",
//    "婚姻状况",
//    "配偶姓名",
//    "配偶身份证",
//    "工作单位(全称)",
//    "所在部门",
//    "职务",
//    "编制",
//    "年收入",
//    "公积金月缴额",
//    "还款方式",
//    "期限",
//    "征信账号",
//    "征信密码",
//    "征信验证码",
//    "公积金账号",
//    "公积金密码",
//    "政务网账号",
//    "政务网密码",
//  ];
//  final List<String> hint = <String>[
//    "请输入姓名",
//    "请输入身份证",
//    "请选择性别",
//    "请选择婚姻状况",
//    "请输入配偶姓名",
//    "请输入配偶身份证",
//    "请输入工作单位(全称)",
//    "请输入所在部门",
//    "请输入职务",
//    "请选择编制",
//    "请输入年收入",
//    "请输入公积金月缴额",
//    "请选择还款方式",
//    "请输入期限",
//    "请输入征信账号",
//    "请输入征信密码",
//    "请输入征信验证码",
//    "请输入公积金账号",
//    "请输入公积金密码",
//    "请输入政务网账号",
//    "请输入政务网密码",
//  ];
//  final List<InputType> type = <InputType>[
//    InputType.TEXT, //"姓名",
//    InputType.TEXT, //"身份证",
//    InputType.SELECT, //"性别",
//    InputType.SELECT, //"婚姻状况",
//    InputType.TEXT, //"配偶姓名",
//    InputType.TEXT, //"配偶身份证",
//    InputType.TEXT, //"工作单位(全称)"
//    InputType.TEXT, //"所在部门",
//    InputType.TEXT, //"职务",
//    InputType.SELECT, //"编制",
//    InputType.TEXT, //"年收入",
//    InputType.TEXT, //"公积金月缴额",
//    InputType.SELECT, //"还款方式",
//    InputType.TEXT, //"期限",
//    InputType.TEXT, //"征信账号",
//    InputType.TEXT, //"征信密码",
//    InputType.TEXT, //"征信验证码",
//    InputType.TEXT, //"公积金账号",
//    InputType.TEXT, //"公积金密码",
//    InputType.TEXT, //"政务网账号",
//    InputType.TEXT, //"政务网密码",
//  ];
//
//  final List<bool> imperative = <bool>[
//    true, //"姓名",
//    true, //"身份证",
//    true, //"性别",
//    true, //"婚姻状况",
//    true, //"配偶姓名",
//    true, //"配偶身份证",
//    true, //"工作单位(全称)"
//    true, //"所在部门",
//    true, //"职务",
//    true, //"编制",
//    true, //"年收入",
//    true, //"公积金月缴额",
//    true, //"还款方式",
//    true, //"期限",
//    true, //"征信账号",
//    true, //"征信密码",
//    true, //"征信验证码",
//    true, //"公积金账号",
//    true, //"公积金密码",
//    false, //"政务网账号",
//    false, //"政务网密码",
//  ];
//  final List<String> suffix = <String>[
//    null, //"姓名",
//    null, //"身份证",
//    null, //"性别",
//    null, //"婚姻状况",
//    null, //"配偶姓名",
//    null, //"配偶身份证",
//    null, //"工作单位(全称)"
//    null, //"所在部门",
//    null, //"职务",
//    null, //"编制",
//    "万元", //"年收入",
//    "元", //"公积金月缴额",
//    null, //"还款方式",
//    "月", //"期限",
//    null, //"征信账号",
//    null, //"征信密码",
//    null, //"征信验证码",
//    null, //"公积金账号",
//    null, //"公积金密码",
//    null, //"政务网账号",
//    null, //"政务网密码",
//  ];
//
//  final Map<String, TextEditingController> controller = {
//    "real_name": new TextEditingController(), //"姓名",
//    "id_card_no": new TextEditingController(), //"身份证",
//    "gender": new TextEditingController(), //"性别",
//    "marital_status": new TextEditingController(), //"婚姻状况",
//    "couple_real_name": new TextEditingController(), //"配偶姓名",
//    "couple_id_card_no": new TextEditingController(), //"配偶身份证",
//    "company_name": new TextEditingController(), //"工作单位(全称)"
//    "department": new TextEditingController(), //"所在部门",
//    "position_level": new TextEditingController(), //"职务",
//    "staffing": new TextEditingController(), //"编制",
//    "year_income": new TextEditingController(), //"年收入",
//    "foundation_month_amount": new TextEditingController(), //"公积金月缴额",
//    "repayment_type": new TextEditingController(), //"还款方式",
//    "term": new TextEditingController(), //"期限",
//    "credit_account": new TextEditingController(), //"征信账号",
//    "credit_account_password": new TextEditingController(), //"征信密码",
//    "credit_account_code": new TextEditingController(), //"征信验证码",
//    "foundation_account": new TextEditingController(), //"公积金账号",
//    "foundation_account_password": new TextEditingController(), //"公积金密码",
//    "gov_affairs_account": new TextEditingController(), //"政务网账号",
//    "gov_affairs_account_password": new TextEditingController(), //"政务网密码",
//  };
//  final Map<String, TransformRule> rule = {
//    "real_name": new S2STransformRule(), //"姓名",
//    "id_card_no": new S2STransformRule(), //"身份证",
//    "gender": new GenderRule(), //"性别",
//    "marital_status": new MarriageRule(), //"婚姻状况",
//    "couple_real_name": new S2STransformRule(), //"配偶姓名",
//    "couple_id_card_no": new S2STransformRule(), //"配偶身份证",
//    "company_name": new S2STransformRule(), //"工作单位(全称)"
//    "department": new S2STransformRule(), //"所在部门",
//    "position_level": new S2STransformRule(), //"职务",
//    "staffing": new StaffingRule(), //"编制",
//    "year_income": new S2STransformRule(), //"年收入",
//    "foundation_month_amount": new S2STransformRule(), //"公积金月缴额",
//    "repayment_type": new RepaymentTypeRule(), //"还款方式",
//    "term": new S2STransformRule(), //"期限",
//    "credit_account": new S2STransformRule(), //"征信账号",
//    "credit_account_password": new S2STransformRule(), //"征信密码",
//    "credit_account_code": new S2STransformRule(), //"征信验证码",
//    "foundation_account": new S2STransformRule(), //"公积金账号",
//    "foundation_account_password": new S2STransformRule(), //"公积金密码",
//    "gov_affairs_account": new S2STransformRule(), //"政务网账号",
//    "gov_affairs_account_password": new S2STransformRule(), //"政务网密码",
//  };
//
  final List<String> keys = [
    "real_name", //"姓名",
    "id_card_no", //"身份证",
    "gender", //"性别",
    "marital_status", //"婚姻状况",
    "couple_real_name", //"配偶姓名",
    "couple_id_card_no", //"配偶身份证",
    "company_name", //"工作单位(全称)"
    "department", //"所在部门",
    "position_level", //"职务",
    "staffing", //"编制",
    "year_income", //"年收入",
    "foundation_month_amount", //"公积金月缴额",
    "repayment_type", //"还款方式",
    "term", //"期限",
    "credit_account", //"征信账号",
    "credit_account_password", //"征信密码",
    "credit_account_code", //"征信验证码",
    "foundation_account", //"公积金账号",
    "foundation_account_password", //"公积金密码",
    "gov_affairs_account", //"政务网账号",
    "gov_affairs_account_password", //"政务网密码",
  ];

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
                if (index == ruleUi.length * 2)
                  return new JunButton(() {}, "保存");
                if (index.isEven)
                  return _buildRowSliver(

                      ruleUi[keys[index ~/ 2]].title,
                      ruleUi[keys[index ~/ 2]].hint,
                      ruleUi[keys[index ~/ 2]].type,
                      ruleUi[keys[index ~/ 2]].imperative,
                      ruleUi[keys[index ~/ 2]].controller,
                      suffix: ruleUi[keys[index ~/ 2]].suffix);
                else
                  return _buildSeparatorSliver();
              },
              itemCount: ruleUi.length * 2 + 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowSliver(String title, String hint, InputType type,
      bool imperative, TextEditingController controller,
      {VoidCallback onPress, String suffix}) {
    return new Row(
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
                    text: title, style: baseTextStyle.copyWith(fontSize: 18.0)),
              ])),
            ],
          ),
        ),
        Expanded(
            child: GestureDetector(
          onTap: type == InputType.SELECT ? () {} : null,
          child: TextField(
            controller: controller,
            enabled: type == InputType.TEXT,
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
          ),
        )),
        suffix != null
            ? new Padding(
                padding: EdgeInsets.all(8.0),
                child: new Text(suffix),
              )
            : new Container()
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
