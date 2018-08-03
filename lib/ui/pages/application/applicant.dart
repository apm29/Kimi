import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_office/main.dart';
import 'package:flutter_office/model/api.dart';
import 'package:flutter_office/model/model.dart';
import 'package:flutter_office/text_style.dart';
import 'package:flutter_office/ui/pages/application/personal_info.dart';
import 'package:flutter_office/ui/widget.dart';

typedef void PressSliver(BuildContext context);

class ApplicantPage extends StatefulWidget {
  final id;

  ApplicantPage(this.id);

  @override
  State<StatefulWidget> createState() {
    return new ApplicantState(id);
  }
}

class ApplicantState extends State<ApplicantPage> {
  final applicationId;

  Applicant applicant;

  ApplicantState(this.applicationId);

  CancelToken cancelToken = new CancelToken();

  @override
  void initState() {
    super.initState();
    if (applicationId == 0) {
      //本地新进件
      Applicant applicant = new Applicant({
        "is_editable": true,
        "vehicle": <Vehicle>[],
        "house": <House>[],
        "id": null,
        "job": {},
        "profile": {}
      });
      calculateProgress();
      setState(() {
        this.applicant = applicant;
      });
    } else {
      //已有进件
      info(context, cancelToken, applicationId).then((resp) {
        BaseResp<Applicant> baseResp = new BaseResp(resp.data);
        print(baseResp);
        calculateProgress();
        setState(() {
          applicant = baseResp.data;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          new GradientAppBar("进件人信息"),
          new Expanded(
            child: new Column(
              children: <Widget>[
                _buildInfoSliver(context, "申请人信息", _toPersonalInfo,
                    applicantPersonalInfoProgress),
                _buildSeparatorSliver(),
                _buildInfoSliver(context, "家庭财产", _toAssetsInfo,
                    applicantAssetsInfoProgress),
                _buildSeparatorSliver(),
                _buildSubmitButton(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Expanded(
        child: Container(
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.symmetric(horizontal: 64.0),
      child: new MaterialButton(
        minWidth: 200.0,
        onPressed: (applicant?.is_editable == true) ? () {} : null,
        color: (applicant?.is_editable == true) ? gold : Colors.grey,
        splashColor: Colors.amberAccent,
        child: new Text(
          "提交",
          style: headerTitleStyle,
        ),
      ),
    ));
  }

  Widget _buildSeparatorSliver() {
    return new Container(
      color: Colors.black12,
      height: 1.0,
    );
  }

  Widget _buildInfoSliver(
      BuildContext context, String text, PressSliver call, double progress) {
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
              progress != 0 ? "${progress * 100}%" : "未填写",
              style: hintTextStyle,
            ),
            new Icon(Icons.keyboard_arrow_right)
          ],
        ),
      ),
    );
  }

  double applicantPersonalInfoProgress = 0.0;
  double applicantAssetsInfoProgress = 0.0;

  void calculateProgress() async {
    //个人信息
    int count = 0;
    int completed = 0;
    Map<String, dynamic> map = json.decode(applicant.profile.toString());
    for (String key in map.keys) {
      if (key == "id") continue;
      if (key == "allow_field") continue;
      if (map[key] != null) {
        completed++;
      }
      count++;
    }
    //工作信息
    Map<String, dynamic> mapJ = json.decode(applicant.job.toString());
    for (String key in mapJ.keys) {
      if (key == "id") continue;
      if (key == "allow_field") continue;
      if (mapJ[key] != null) {
        completed++;
      }
      count++;
    }
    print(completed);
    print(count);
    setState(() {
      applicantPersonalInfoProgress = completed / count;
    });

    //车辆
    count = 0;
    completed = 0;
    if (applicant.vehicle != null)
      for (Vehicle vehicle in applicant.vehicle) {
        Map<String, dynamic> mapV = json.decode(vehicle.toString());
        bool filled = true;
        for (String key in mapV.keys) {
          if (key == "id") continue;
          if (key == "allow_field") continue;
          if (mapV[key] == null) filled = false;
        }
        count++;
        if (filled) completed++;
      }
    //房屋
    if (applicant.house != null) {
      for (House house in applicant.house) {
        Map<String, dynamic> mapH = json.decode(house.toString());
        bool filled = true;
        for (String key in mapH.keys) {
          if (key == "id") continue;
          if (key == "allow_field") continue;
          if (mapH[key] == null) filled = false;
        }
        count++;
        if (filled) completed++;
      }
    }
    if (applicant.house == null || applicant.house.length == 0) {
      count++;
    }
    print(completed);
    print(count);

    setState(() {
      applicantAssetsInfoProgress = completed / count;
    });
  }

  void _toAssetsInfo(BuildContext context) {}

  void _toPersonalInfo(BuildContext context) {
    Navigator.of(context).push(new PageRouteBuilder(pageBuilder: (a, b, c) {
      return new ApplicantPersonalInfoPage(applicationId);
    }));
  }
}
