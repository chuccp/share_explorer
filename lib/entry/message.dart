class Message {

  Message({required this.ok, required this.msg, required this.code,this.data});

  bool ok;

  int code;

  String msg;

  dynamic? data;
}