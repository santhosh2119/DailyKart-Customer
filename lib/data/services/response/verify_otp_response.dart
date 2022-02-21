// To parse this JSON data, do
//
//     final verifyOtpResponse = verifyOtpResponseFromJson(jsonString);

import 'dart:convert';

VerifyOtpResponse verifyOtpResponseFromJson(String str) => VerifyOtpResponse.fromJson(json.decode(str));

String verifyOtpResponseToJson(VerifyOtpResponse data) => json.encode(data.toJson());

class VerifyOtpResponse {
  VerifyOtpResponse({
    this.status,
    this.message,
    this.userid,
    this.stepsCompleted,
  });

  bool status;
  String message;
  String userid;
  int stepsCompleted;

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) => VerifyOtpResponse(
    status: json["status"],
    message: json["message"],
    userid: json["userid"],
    stepsCompleted: json["steps_completed"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "userid": userid,
    "steps_completed": stepsCompleted,
  };
}
