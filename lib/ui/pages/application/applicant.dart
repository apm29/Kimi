import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_office/const.dart';
import 'package:flutter_office/main.dart';
import 'package:flutter_office/model/api.dart';
import 'package:flutter_office/model/model.dart';
import 'package:flutter_office/text_style.dart';
import 'package:flutter_office/ui/pages/application/personal_info.dart';
import 'package:flutter_office/ui/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      applicant = new Applicant.empty();
      /**
       * "is_editable": true,
          "vehicle": <Vehicle>[],
          "house": <House>[],
          "id": 0,
          "job": {},
          "profile": {}
       */
      applicant.is_editable = true;
      applicant.vehicle = [];
      applicant.house = [];
      applicant.application_id = 0;
      applicant.job = new Job.empty();
      print(applicant.profile.allow_field);
      applicant.profile = new Profile.empty();
      print(applicant.profile.allow_field);

      save2Sp(applicant);
      calculateProgress();
    } else {
      //已有进件
      info(context, cancelToken, applicationId).then((resp) {
        BaseResp<Applicant> baseResp = new BaseResp(resp.data);
        applicant = baseResp.data;
        calculateProgress();
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
    Map<String, dynamic> mapProfile = json.decode(applicant.profile.toString());
    print(mapProfile);
    for (String key in mapProfile.keys) {
      if (key == "id") continue;
      if (key == "allow_field") continue;
      if (mapProfile[key] != null) {
        if((mapProfile[key] is num && mapProfile[key]!=0 ))
          completed++;
        if(!(mapProfile[key] is num)){
          completed++;
        }
      }
      count++;
    }
    print('$completed/$count');
    //工作信息
    Map<String, dynamic> mapJob = json.decode(applicant.job.toString());
    for (String key in mapJob.keys) {
      if (key == "id") continue;
      if (key == "allow_field") continue;
      if (mapJob[key] != null) {
        if((mapJob[key] is num && mapJob[key]!=0 ))
          completed++;
        if(!(mapJob[key] is num)){
          completed++;
        }
      }
      count++;
    }
    print('$completed/$count');
    setState(() {
      applicantPersonalInfoProgress = completed / count;
    });

    //车辆
    count = 0;
    completed = 0;
    if (applicant.vehicle != null)
      for (Vehicle vehicle in applicant.vehicle) {
        Map<String, dynamic> mapVehicle = json.decode(vehicle.toString());
        bool filled = true;
        for (String key in mapVehicle.keys) {
          if (key == "id") continue;
          if (key == "allow_field") continue;
          if (mapVehicle[key] == null) filled = false;
        }
        count++;
        if (filled) completed++;
      }
    //房屋
    if (applicant.house != null) {
      for (House house in applicant.house) {
        Map<String, dynamic> mapHouse = json.decode(house.toString());
        bool filled = true;
        for (String key in mapHouse.keys) {
          if (key == "id") continue;
          if (key == "allow_field") continue;
          if (mapHouse[key] == null) filled = false;
        }
        count++;
        if (filled) completed++;
      }
    }
    if (applicant.house == null || applicant.house.length == 0) {
      count++;
    }

    setState(() {
      applicantAssetsInfoProgress = completed / count;
    });
  }

  void _toAssetsInfo(BuildContext context) {

  }

  void _toPersonalInfo(BuildContext context) {
    Navigator.of(context).push(new PageRouteBuilder(pageBuilder: (a, b, c) {
      return new ApplicantPersonalInfoPage(applicationId);
    }));
  }

  void save2Sp(Applicant applicant) async{
    var instance =await SharedPreferences.getInstance();
    var userName = instance.getString(applicant_local_user_name);
    var userIdCard = instance.getString(applicant_local_user_idNo);

    instance.setString('$applicant_local$applicationId', applicant.toString());

    setState(() {
      applicant.profile.real_name = userName;
      applicant.profile.id_card_no = userIdCard;
    });
  }
}
