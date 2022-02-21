
class ProfileDataRequest {
  final String name,alt_number,email,city,area,locality,address,gps_loc,userid,password,
      refid,house_no,
  landmark,areanotlisted,latlong,firebaseToken;


  ProfileDataRequest({this.name, this.alt_number, this.email,
    this.city, this.area, this.locality,
    this.address, this.gps_loc, this.userid,
    this.password, this.refid, this.house_no,

    this.landmark, this.areanotlisted, this.latlong,
    this.firebaseToken});



  factory ProfileDataRequest.fromJson(Map json) {
    return ProfileDataRequest(
      name: json['name'],
      alt_number: json['alt_number'],
      email: json['email'],
      city: json['city'],
      area: json['area'],
      locality: json['locality'],
      address: json['address'],
      gps_loc: json['gps_loc'],
      userid: json['userid'],
      password: json['password'],
      refid: json['refid'],
      house_no: json['house_no'],
      landmark: json['landmark'],
      areanotlisted: json['areanotlisted'],
      latlong: json['latlong'],
      firebaseToken: json['firebaseToken'],
    );
  }

  Map toMap() {
    var map = new Map();
    map["name"] = name;
    map["alt_number"] = alt_number;
    map["email"] = email;
    map["city"] = city;
    map["area"] = area;
    map["locality"] = locality;
    map["address"] = address;
    map["gps_loc"] = gps_loc;
    map["userid"] = userid;
    map["password"] = password;
    map["refid"] = refid;
    map["house_no"] = house_no;
    map["landmark"] = landmark;
    map["areanotlisted"] = areanotlisted;
    map["latlong"] = latlong;
    map["firebaseToken"] = firebaseToken;
    return map;
  }

}