class UpdatePasswordRequest {
  final String userid;
  final String password;


  UpdatePasswordRequest({this.userid, this.password});

  factory UpdatePasswordRequest.fromJson(Map json) {
    return UpdatePasswordRequest(
      userid: json['userid'],
      password: json['password'],
    );
  }

  Map toMap() {
    var map = new Map();
    map["userid"] = userid;
    map["password"] = password;

    return map;
  }
}