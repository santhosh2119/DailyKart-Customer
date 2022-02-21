// To parse this JSON data, do
//
//     final rewardsResponse = rewardsResponseFromJson(jsonString);

import 'dart:convert';

RewardsResponse rewardsResponseFromJson(String str) => RewardsResponse.fromJson(json.decode(str));

String rewardsResponseToJson(RewardsResponse data) => json.encode(data.toJson());

class RewardsResponse {
  RewardsResponse({
    this.status,
    this.message,
    this.userdata,
    this.referals,
    this.referalBonus,
    this.rewardBonus,
  });

  bool status;
  String message;
  Userdata userdata;
  List<dynamic> referals;
  String referalBonus;
  dynamic rewardBonus;

  factory RewardsResponse.fromJson(Map<String, dynamic> json) => RewardsResponse(
    status: json["status"],
    message: json["message"],
    userdata: Userdata.fromJson(json["userdata"]),
    referals: List<dynamic>.from(json["referals"].map((x) => x)),
    referalBonus: json["referal_bonus"],
    rewardBonus: json["reward_bonus"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "userdata": userdata.toJson(),
    "referals": List<dynamic>.from(referals.map((x) => x)),
    "referal_bonus": referalBonus,
    "reward_bonus": rewardBonus,
  };
}

class Userdata {
  Userdata({
    this.userid,
    this.userMobile,
    this.userOtp,
    this.userLocation,
    this.userName,
    this.altNumber,
    this.userEmail,
    this.password,
    this.areanotlisted,
    this.userCity,
    this.userArea,
    this.houseNo,
    this.landmark,
    this.areaDeliveryStatus,
    this.userLocality,
    this.userCurrentAddress,
    this.userGps,
    this.latlong,
    this.userStatus,
    this.userCreated,
    this.firebaseToken,
    this.stepsCompleted,
    this.referalCode,
  });

  String userid;
  String userMobile;
  String userOtp;
  String userLocation;
  String userName;
  String altNumber;
  String userEmail;
  String password;
  String areanotlisted;
  String userCity;
  String userArea;
  String houseNo;
  String landmark;
  String areaDeliveryStatus;
  String userLocality;
  String userCurrentAddress;
  String userGps;
  String latlong;
  String userStatus;
  DateTime userCreated;
  String firebaseToken;
  String stepsCompleted;
  String referalCode;

  factory Userdata.fromJson(Map<String, dynamic> json) => Userdata(
    userid: json["userid"],
    userMobile: json["user_mobile"],
    userOtp: json["user_otp"],
    userLocation: json["user_location"],
    userName: json["user_name"],
    altNumber: json["alt_number"],
    userEmail: json["user_email"],
    password: json["password"],
    areanotlisted: json["areanotlisted"],
    userCity: json["user_city"],
    userArea: json["user_area"],
    houseNo: json["house_no"],
    landmark: json["landmark"],
    areaDeliveryStatus: json["area_delivery_status"],
    userLocality: json["user_locality"],
    userCurrentAddress: json["user_current_address"],
    userGps: json["user_gps"],
    latlong: json["latlong"],
    userStatus: json["user_status"],
    userCreated: DateTime.parse(json["user_created"]),
    firebaseToken: json["firebase_token"],
    stepsCompleted: json["steps_completed"],
    referalCode: json["referal_code"],
  );

  Map<String, dynamic> toJson() => {
    "userid": userid,
    "user_mobile": userMobile,
    "user_otp": userOtp,
    "user_location": userLocation,
    "user_name": userName,
    "alt_number": altNumber,
    "user_email": userEmail,
    "password": password,
    "areanotlisted": areanotlisted,
    "user_city": userCity,
    "user_area": userArea,
    "house_no": houseNo,
    "landmark": landmark,
    "area_delivery_status": areaDeliveryStatus,
    "user_locality": userLocality,
    "user_current_address": userCurrentAddress,
    "user_gps": userGps,
    "latlong": latlong,
    "user_status": userStatus,
    "user_created": userCreated.toIso8601String(),
    "firebase_token": firebaseToken,
    "steps_completed": stepsCompleted,
    "referal_code": referalCode,
  };
}
