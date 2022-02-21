// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.status,
    this.message,
    this.userid,
    this.freeSample,
    this.logintype,
    this.stepsCompleted,
  });

  bool status;
  String message;
  String userid;
  String freeSample;
  String logintype;
  String stepsCompleted;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    status: json["status"],
    message: json["message"],
    userid: json["userid"],
    freeSample: json["free_sample"],
    logintype: json["logintype"],
    stepsCompleted: json["steps_completed"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "userid": userid,
    "free_sample": freeSample,
    "logintype": logintype,
    "steps_completed": stepsCompleted,
  };
}
