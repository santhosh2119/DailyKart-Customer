
/*import 'package:json_annotation/json_annotation.dart';
part 'LoginRequest.g.dart';

@JsonSerializable()
class LoginRequest{

  String mobile;
  String password;
  String firebaseToken="tempToken";


  LoginRequest({this.mobile, this.password,this.firebaseToken});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$LoginRequestFromJson()` constructor.
  /// The constructor is named after the source class, in this case, LoginRequest.
  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$LoginRequestToJson`.
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

}*/

class LoginRequest {
  final String mobile;
  final String password;
  final String firebaseToken;

  LoginRequest({this.mobile, this.password, this.firebaseToken});

  factory LoginRequest.fromJson(Map json) {
    return LoginRequest(
      mobile: json['mobile'],
      password: json['password'],
      firebaseToken: json['firebaseToken'],
    );
  }

  Map toMap() {
    var map = new Map();
    map["mobile"] = mobile;
    map["password"] = password;
    map["firebaseToken"] = firebaseToken;

    return map;
  }
}