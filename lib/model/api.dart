import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_office/model/model.dart';

Options options = new Options(
  responseType: ResponseType.JSON,
  baseUrl: "http://office-api.junleizg.com.cn",
  connectTimeout: 5000,
  receiveTimeout: 3000,
  headers: {"Content-Type": "Application/json"},
);
Dio dio = new Dio(options);
Map data = {"access_token": "934d49dd8198b1830158b226ec2c0ec1"};

Future<BaseResp> profile() {
  dio.transFormer = new DefaultTransformer();

  return dio.post("/v1/user/profile", data: data).then((v) {});
}
