// To parse this JSON data, do
//
//     final notificationsDataResponse = notificationsDataResponseFromJson(jsonString);

import 'dart:convert';

NotificationsDataResponse notificationsDataResponseFromJson(String str) => NotificationsDataResponse.fromJson(json.decode(str));

String notificationsDataResponseToJson(NotificationsDataResponse data) => json.encode(data.toJson());

class NotificationsDataResponse {
  NotificationsDataResponse({
    this.status,
    this.data,
  });

  bool status;
  List<NotificationsNew> data;

  factory NotificationsDataResponse.fromJson(Map<String, dynamic> json) => NotificationsDataResponse(
    status: json["status"],
    data: List<NotificationsNew>.from(json["data"].map((x) => NotificationsNew.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NotificationsNew {
  NotificationsNew({
    this.id,
    this.userId,
    this.message,
    this.title,
    this.image,
    this.status,
    this.createdDate,
  });

  String id;
  String userId;
  String message;
  String title;
  String image;
  Status status;
  DateTime createdDate;

  factory NotificationsNew.fromJson(Map<String, dynamic> json) => NotificationsNew(
    id: json["id"],
    userId: json["user_id"],
    message: json["message"],
    title: json["title"],
    image: json["image"],
    status: statusValues.map[json["status"]],
    createdDate: DateTime.parse(json["createdDate"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "message": message,
    "title": title,
    "image": image,
    "status": statusValues.reverse[status],
    "createdDate": createdDate.toIso8601String(),
  };
}

enum Status { UNREAD }

final statusValues = EnumValues({
  "unread": Status.UNREAD
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
