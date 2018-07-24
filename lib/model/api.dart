import 'dart:async';

import 'package:flutter_office/model/base.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';


Map map = {
  "Content-Type":"Application/json"
};
Map body={
  "access_token": "934d49dd8198b1830158b226ec2c0ec1"
};

final host = "http://office-api.junleizg.com.cn";


class Api{
  void profile() async{

    Future<http.Response> future = http.post(host,headers: map,body: body.toString());
    future.then((response){
      print(response.body);
    }).catchError((e){
      print("错误:$e");
    },test:(error){
      print("错误:$error");
      return true;
    }).whenComplete((){
      print("完成请求");
    });


    Dio dio = new Dio();
    Response response=await dio.get("https://www.google.com/");
    print(response.data);

  }
}
void main(){
  new Api().profile();
}