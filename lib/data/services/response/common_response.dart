// To parse this JSON data, do
//
//     final updatePasswordResponse = updatePasswordResponseFromJson(jsonString);

import 'dart:convert';

CommonResponse updatePasswordResponseFromJson(String str) => CommonResponse.fromJson(json.decode(str));

String updatePasswordResponseToJson(CommonResponse data) => json.encode(data.toJson());

class CommonResponse {
  CommonResponse({
    this.status,
    this.message,
  });

  bool status;
  String message;

  factory CommonResponse.fromJson(Map<String, dynamic> json) => CommonResponse(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
