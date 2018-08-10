import 'dart:async';
import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter_office/model/sound_model.dart';

Dio dio;
Map<String, dynamic> map = {
  "access_token": "ooo3iogfr9rfvqmhakk6nulit4",
  "registration_id": "100d8559094c0f000c0",
  "_app_type": "android",
  "is_simulator": "false",
  "version_code": "1.3.0-33",
};

Future<BaseResp> post(
    String url, Type t, Map<String, dynamic> bizContent) async {
  if (dio == null) dio = initDioInstance();
  map["biz_content"] = bizContent;
  var post = await dio.post(url, data: map);
  return new BaseResp.fromType(post.data.toString().trim(), t);
}
///
/// 初始化dio实例
///
Dio initDioInstance() {
  var options = new Options(
      baseUrl: "http://office-api.junleizg.com.cn",
      headers: {"Content-type": "application/json"},
      responseType: ResponseType.PLAIN);
  var dio = new Dio(options);

  dio.interceptor.response.onError = (e) {
    print('error:$e');
  };
  dio.interceptor.response.onSuccess = (res) {
    printJsonFormat(res.data.toString());
    return res;
  };

  return dio;
}

///
/// 将字符串格式化为json形式
///
///
void printJsonFormat(String jsonString,
    {String newLine = "\n|\t",
    indentContent = "    ",
    suffix =
        " \n----------------------------------------------------------------",
    prefix =
        " \n----------------------------------------------------------------"}) {
  var charList = jsonString.split("");
  StringBuffer content = new StringBuffer(prefix);
  ListQueue opQueue = new ListQueue();
  int indent = 0;
  bool shouldIndent = false;
  charList.forEach((s) {
    if (s != " "&&s != "\t"&&s != "\n") {//去除空格
      if (s == "[" || s == "{") {
        opQueue.add(s);

        content.write(newLine);
        addTabString(content, indent, indentContent: indentContent);
        content.write(s + newLine);
        indent++;
        shouldIndent = true;
      } else if (s == "}" || s == "]") {
        opQueue.add(s);
        indent--;
        content.write(newLine);
        addTabString(content, indent, indentContent: indentContent);
        content.write(s + newLine);
        shouldIndent = true;
      } else if (s == ",") {
        if (opQueue.length != 0 && (opQueue.last == "]" || opQueue.last == "}"))
          addTabString(content, indent, indentContent: indentContent);
        content.write(s + newLine);
        shouldIndent = true;
      } else {
        if (shouldIndent) {
          addTabString(content, indent, indentContent: indentContent);
          content.write(s);
          shouldIndent = false;
        } else
          content.write(s);
      }
    }
  });

  content.write(suffix);
  print(content);
}
///
/// 添加count个缩进
///
StringBuffer addTabString(StringBuffer buff, int count,
    {String indentContent = "    "}) {
  for (int i = 0; i < count; i++) {
    buff.write(indentContent);
  }
  return buff;
}

Future<BaseResp<Application>> info(int id) {
  return post("/v1/application/info", Application, {"id": id});
}

