// To parse this JSON data, do
//
//     final locationResponse = locationResponseFromJson(jsonString);

import 'dart:convert';

LocationResponse locationResponseFromJson(String str) => LocationResponse.fromJson(json.decode(str));

String locationResponseToJson(LocationResponse data) => json.encode(data.toJson());

class LocationResponse {
  LocationResponse({
    this.status,
    this.locations,
  });

  bool status;
  List<LocationData> locations;

  factory LocationResponse.fromJson(Map<String, dynamic> json) => LocationResponse(
    status: json["status"],
    locations: List<LocationData>.from(json["locations"].map((x) => LocationData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "locations": List<dynamic>.from(locations.map((x) => x.toJson())),
  };
}

class LocationData {
  LocationData({
    this.id,
    this.location,
    this.deliveryCharges,
    this.cutoffCharges,
    this.image,
    this.status,
    this.deleted,
    this.createdDate,
    this.updatedDate,
  });

  String id;
  String location;
  String deliveryCharges;
  String cutoffCharges;
  String image;
  String status;
  String deleted;
  DateTime createdDate;
  DateTime updatedDate;

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
    id: json["id"],
    location: json["location"],
    deliveryCharges: json["deliveryCharges"],
    cutoffCharges: json["cutoffCharges"],
    image: json["image"],
    status: json["status"],
    deleted: json["deleted"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "location": location,
    "deliveryCharges": deliveryCharges,
    "cutoffCharges": cutoffCharges,
    "image": image,
    "status": status,
    "deleted": deleted,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
  };
}
