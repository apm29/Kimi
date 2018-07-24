

class BaseResp<T>{
  String msg;
  int code;
  T data;

  BaseResp(this.msg, this.code, this.data);

}