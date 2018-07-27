import 'dart:convert' show json;

class BaseResp<T> {
  String msg;
  int code;
  T data;

  BaseResp(String data) {
    Map<String,dynamic> map = json.decode(data);
    this.msg = map["msg"];
    this.code = map["code"];
    switch(T){
      case Profile:
        map["data"] = map["data"]==null?null:Profile.fromJson(map["data"]);
        break;
      case Login:
        map["data"] = map["data"]==null?null:Login.fromJson(map["data"]);
        break;
    }
    this.data = map["data"];
  }

  bool isSuccess() {
    return code ==200;
  }
}

abstract class FromJson{
  FromJson.fromJson(String json);
}
class Profile{

  int is_master;
  int is_real;
  int type;
  String mobile;
  String parent_mobile;
  String parent_real_name;


  Profile.fromParams({this.is_master, this.is_real, this.type, this.mobile, this.parent_mobile, this.parent_real_name});

  factory Profile(jsonStr) => jsonStr is String ? Profile.fromJson(json.decode(jsonStr)) : Profile.fromJson(jsonStr);

  Profile.fromJson(jsonRes) {
    is_master = jsonRes['is_master'];
    is_real = jsonRes['is_real'];
    type = jsonRes['type'];
    mobile = jsonRes['mobile'];
    parent_mobile = jsonRes['parent_mobile'];
    parent_real_name = jsonRes['parent_real_name'];

  }

  @override
  String toString() {
    return '{"is_master": $is_master,"is_real": $is_real,"type": $type,"mobile": ${mobile != null?'${json.encode(mobile)}':'null'},"parent_mobile": ${parent_mobile != null?'${json.encode(parent_mobile)}':'null'},"parent_real_name": ${parent_real_name != null?'${json.encode(parent_real_name)}':'null'}}';
  }
}


class Login {

  String access_token;


  Login.fromParams({this.access_token});

  factory Login(jsonStr) => jsonStr is String ? Login.fromJson(json.decode(jsonStr)) : Login.fromJson(jsonStr);

  Login.fromJson(jsonRes) {
    access_token = jsonRes['access_token'];
  }

  @override
  String toString() {
    return '{"access_token": ${access_token != null?'${json.encode(access_token)}':'null'}}';
  }
}
