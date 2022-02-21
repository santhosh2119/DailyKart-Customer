import 'dart:convert';

import 'package:fooddelivery/data/services/response/product_info_model.dart';

FavouriteDataResponse favouriteDataResponseFromJson(String str) => FavouriteDataResponse.fromJson(json.decode(str));

String favouriteDataResponseToJson(FavouriteDataResponse data) => json.encode(data.toJson());

class FavouriteDataResponse {
  FavouriteDataResponse({
    this.status,
    this.favouriteData,
  });

  bool status;
  List<ProductInfoModel> favouriteData;

  factory FavouriteDataResponse.fromJson(Map<String, dynamic> json) => FavouriteDataResponse(
    status: json["status"],
    favouriteData: List<ProductInfoModel>.from(json["data"].map((x) => ProductInfoModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(favouriteData.map((x) => x.toJson())),

  };
}

