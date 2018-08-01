import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_office/ui/pages/login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

Options options = new Options(
  responseType: ResponseType.PLAIN,
  baseUrl: "http://office-api.junleizg.com.cn",
  connectTimeout: 5000,
  receiveTimeout: 3000,
  headers: {"Content-Type": "Application/json"},
);
Dio dio = new Dio(options);
Map data = {
  "access_token": "",
  "platform": "android-flutter",
  "_app_type": "android"
};
SharedPreferences prefs;

class MyTransformer extends DefaultTransformer {
  @override
  Future transformRequest(Options options) async {
    if (options.data is List) {
      throw new DioError(message: "Can't send List to sever directly");
    } else {
      return super.transformRequest(options);
    }
  }

  /// The [Options] doesn't contain the cookie info. we add the cookie
  /// info to [Options.extra], and you can retrieve it in [ResponseInterceptor]
  /// and [Response] with `response.request.extra["cookies"]`.
  @override
  Future transformResponse(Options options, HttpClientResponse response) async {
    options.extra["cookies"] = response.cookies;
    return super.transformResponse(options, response);
  }
}

void initDio() async {
  dio.interceptor.request.onSend = (Options options) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('access_token');
    data["access_token"] = token;

    print("on REQUEST[method]: ${options.method}");
    print("on REQUEST[headers]: ${options.headers}");
    print("on REQUEST[url]: ${options.baseUrl + options.path}");
    print("on REQUEST[body]: ${options.data}");
    // 在请求被发送之前做一些事情
    return options; //continue
    // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
    // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
    //
    // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
    // 这样请求将被中止并触发异常，上层catchError会被调用。
  };
  dio.interceptor.response.onSuccess = (Response response) {
    // 在返回响应数据之前做一些预处理
    print("on REPONSE[data]: ${response.data}");
//    if(response.data!=null){
//      Map<String,dynamic> decodeMap = json.decode(response.data);
//      if(decodeMap.containsKey("code")&&decodeMap["code"]==401){
//        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context){
//          return new LoginPage();
//        }));
//      }
//    }
    return response; // continue
  };
  dio.interceptor.response.onError = (DioError e) {
    // 当请求失败时做一些预处理
    print(e);
    Fluttertoast.showToast(msg: e.message);
    return DioError; //continue
  };

  dio.transFormer = new MyTransformer();
  prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('access_token');
  data["access_token"] = token;
}

Future<Response> profile(BuildContext context, CancelToken cancelToken) {
  add401Interceptor(context);
  Future<Response> future =
      dio.post("/v1/user/profile", data: data, cancelToken: cancelToken);
  return future;
}

Future<Response> login(
    BuildContext context, CancelToken cancelToken, name, pass) {
  add401Interceptor(context);
  data.clear();
  data["biz_content"] = {
    "username": name,
    "password": pass,
  };
  Future<Response> future =
      dio.post("/v1/user/login", data: data, cancelToken: cancelToken);
  return future;
}
///  13. 进件客户验证
///  POST /v1/application/can
///  Request Body
///  {
///  "biz_content": {
///  "real_name": "汉字是",
///  "id_card_no": "340823199009097619"
///  },
///  "access_token": "934d49dd8198b1830158b226ec2c0ec1"
///  }
Future<Response> can(
    BuildContext context, CancelToken cancelToken, name, idCard) {
  add401Interceptor(context);
  data["biz_content"] = {
    "real_name": name,
    "id_card_no": idCard,
  };
  Future<Response> future =
  dio.post("/v1/application/can", data: data, cancelToken: cancelToken);
  return future;
}

void add401Interceptor(BuildContext context) {
  dio.interceptor.response.onSuccess = (Response response) {
    // 在返回响应数据之前做一些预处理
    print("on REPONSE[data]: ${response.data}");
    if (response.data != null) {
      Map<String, dynamic> decodeMap = json.decode(response.data);
      if (decodeMap.containsKey("code") && decodeMap["code"] == 401) {
        if (decodeMap.containsKey("msg"))
          Fluttertoast.showToast(msg: decodeMap["msg"]);
        Navigator.pushAndRemoveUntil(context,
            new MaterialPageRoute(builder: (context) {
          return new LoginPage();
        }), (route) {
          return false;
        });
      }
    }
    return response; // continue
  };
}
