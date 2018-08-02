import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_office/model/model.dart';

Options options = new Options(
  responseType: ResponseType.PLAIN,
  baseUrl: "http://office-api.junleizg.com.cn",
  connectTimeout: 5000,
  receiveTimeout: 3000,
  headers: {"Content-Type": "Application/json"},
);
Dio dio = new Dio(options);
Map data = {
  "access_token": "ooo3iogfr9rfvqmhakk6nulit4",
  "platform": "android-flutter",
  "_app_type": "android"
};

Future<Response<BaseResp>> info(id) {
  data["biz_content"] = {
    "id": id,
  };
  Future<Response<BaseResp>> post = dio
      .post<BaseResp>("/v1/application/info",
          data: data, cancelToken: new CancelToken()).then((resp){
            print(resp.data.runtimeType);
            BaseResp<Applicant> baseResp = new BaseResp(resp.data as String);
            resp.data = baseResp;
  });
  return post;
}

main() {
  info(274).then((resp) {
    print(resp.data);
  });
}
