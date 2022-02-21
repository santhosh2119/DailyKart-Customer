
/*
import 'package:json_annotation/json_annotation.dart';
part 'VerifyOtpRequest.g.dart';

@JsonSerializable()
class VerifyOtpRequest{

  String mobile;
  String otp;


  VerifyOtpRequest({this.mobile, this.otp});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$LoginRequestFromJson()` constructor.
  /// The constructor is named after the source class, in this case, LoginRequest.
  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) => _$VerifyOtpRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$LoginRequestToJson`.
  Map<String, dynamic> toJson() => _$VerifyOtpRequestToJson(this);

}
*/


class VerifyOtpRequest {
  final String mobile;
  final String otp;


  VerifyOtpRequest({this.mobile, this.otp});

  factory VerifyOtpRequest.fromJson(Map json) {
    return VerifyOtpRequest(
      mobile: json['mobile'],
      otp: json['otp'],
    );
  }

  Map toMap() {
    var map = new Map();
    map["mobile"] = mobile;
    map["otp"] = otp;

    return map;
  }
}