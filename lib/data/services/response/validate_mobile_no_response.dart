// To parse this JSON data, do
//
//     final validateMobileNoResponse = validateMobileNoResponseFromJson(jsonString);

import 'dart:convert';

ValidateMobileNoResponse validateMobileNoResponseFromJson(String str) => ValidateMobileNoResponse.fromJson(json.decode(str));

String validateMobileNoResponseToJson(ValidateMobileNoResponse data) => json.encode(data.toJson());

class ValidateMobileNoResponse {
  ValidateMobileNoResponse({
    this.status,
    this.message,
    this.isRegistered,
    this.stepsCompleted,
  });

  bool status;
  String message;
  bool isRegistered;
  int stepsCompleted;

  factory ValidateMobileNoResponse.fromJson(Map<String, dynamic> json) => ValidateMobileNoResponse(
    status: json["status"],
    message: json["message"],
    isRegistered: json["isRegistered"],
    stepsCompleted: json["steps_completed"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "isRegistered": isRegistered,
    "steps_completed": stepsCompleted,
  };
}
