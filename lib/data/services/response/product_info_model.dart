import 'dart:convert';

import 'package:fooddelivery/data/services/response/product_price.dart';

ProductInfoModel productInfoModelFromJson(String str) => ProductInfoModel.fromJson(json.decode(str));

String productInfoModelToJson(ProductInfoModel data) => json.encode(data.toJson());

class ProductInfoModel {
  ProductInfoModel({
    this.id,
    this.productId,
    this.hsnCode,
    this.productName,
    this.productCategory,
    this.productQuantity,
    this.description,
    this.link,
    this.mImages,
    this.brandname,
    this.target,
    this.location,
    this.productImage,
    this.productBannerImage,
    this.status,
    this.vendor,
    this.msl,
    this.mslOld,
    this.taxClass,
    this.assignedTo,
    this.createdDate,
    this.updatedDate,
    this.deleted,
    this.productSubCategory,
    this.productChildCategory,
    this.varientType,
    this.categoryName,
    this.subCategoryName,
    this.childCategoryName,
    this.productPrice,
    this.isWishlist,
  });

  String id;
  String productId;
  String hsnCode;
  String productName;
  String productCategory;
  String productQuantity;
  String description;
  String link;
  String mImages;
  String brandname;
  String target;
  String location;
  String productImage;
  String productBannerImage;
  String status;
  String vendor;
  String msl;
  dynamic mslOld;
  String taxClass;
  String assignedTo;
  DateTime createdDate;
  DateTime updatedDate;
  String deleted;
  String productSubCategory;
  String productChildCategory;
  String varientType;
  String categoryName;
  dynamic subCategoryName;
  dynamic childCategoryName;
  List<ProductPrice> productPrice;
  bool isWishlist;

  factory ProductInfoModel.fromJson(Map<String, dynamic> json) => ProductInfoModel(
    id: json["id"],
    productId: json["product_id"],
    hsnCode: json["hsn_code"],
    productName: json["product_name"],
    productCategory: json["product_category"],
    productQuantity: json["product_quantity"],
    description: json["description"],
    link: json["link"],
    mImages: json["mImages"],
    brandname: json["brandname"],
    target: json["target"],
    location: json["location"],
    productImage: json["product_image"],
    productBannerImage: json["product_banner_image"],
    status: json["status"],
    vendor: json["vendor"],
    msl: json["msl"],
    mslOld: json["msl_old"],
    taxClass: json["tax_class"],
    assignedTo: json["assigned_to"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    deleted: json["deleted"],
    productSubCategory: json["product_sub_category"],
    productChildCategory: json["product_child_category"],
    varientType: json["varient_type"],
    categoryName: json["category_name"],
    subCategoryName: json["sub_category_name"],
    childCategoryName: json["child_category_name"],
    productPrice: List<ProductPrice>.from(json["product_price"].map((x) => ProductPrice.fromJson(x))),
    isWishlist: json["is_wishlist"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "hsn_code": hsnCode,
    "product_name": productName,
    "product_category": productCategory,
    "product_quantity": productQuantity,
    "description": description,
    "link": link,
    "mImages": mImages,
    "brandname": brandname,
    "target": target,
    "location": location,
    "product_image": productImage,
    "product_banner_image": productBannerImage,
    "status": status,
    "vendor": vendor,
    "msl": msl,
    "msl_old": mslOld,
    "tax_class": taxClass,
    "assigned_to": assignedTo,
    "created_date": createdDate.toIso8601String(),
    "updated_date": updatedDate.toIso8601String(),
    "deleted": deleted,
    "product_sub_category": productSubCategory,
    "product_child_category": productChildCategory,
    "varient_type": varientType,
    "category_name": categoryName,
    "sub_category_name": subCategoryName,
    "child_category_name": childCategoryName,
    "product_price": List<dynamic>.from(productPrice.map((x) => x.toJson())),
    "is_wishlist": isWishlist,
  };
}

