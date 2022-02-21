import 'dart:convert';

import 'package:fooddelivery/data/services/response/product_info_model.dart';

HomeScreenResponse homeScreenResponseFromJson(String str) =>
    HomeScreenResponse.fromJson(json.decode(str));

String homeScreenResponseToJson(HomeScreenResponse data) =>
    json.encode(data.toJson());

class HomeScreenResponse {
  HomeScreenResponse({
    this.status,
    this.cartTotal,
    this.cartCount,
    this.newArrivals,
    this.banners,
    this.recentlyViewed,
    this.categories,
    this.sections,
  });

  bool status;
  String cartTotal;
  int cartCount;
  List<ProductInfoModel> newArrivals;
  List<BannerDataNew> banners;
  List<ProductInfoModel> recentlyViewed;
  List<CategoryDataNew> categories;
  List<dynamic> sections;

  factory HomeScreenResponse.fromJson(Map<String, dynamic> json) =>
      HomeScreenResponse(
        status: json["status"],
        cartTotal: json["cart_total"],
        cartCount: json["cart_count"],
        newArrivals: List<ProductInfoModel>.from(
            json["new_arrivals"].map((x) => ProductInfoModel.fromJson(x))),
        banners: List<BannerDataNew>.from(
            json["banners"].map((x) => BannerDataNew.fromJson(x))),
        recentlyViewed: List<ProductInfoModel>.from(
            json["recently_viewed"].map((x) => ProductInfoModel.fromJson(x))),
        categories: List<CategoryDataNew>.from(
            json["categories"].map((x) => CategoryDataNew.fromJson(x))),
        sections: List<dynamic>.from(json["sections"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "cart_total": cartTotal,
        "cart_count": cartCount,
        "new_arrivals": List<dynamic>.from(newArrivals.map((x) => x.toJson())),
        "banners": List<dynamic>.from(banners.map((x) => x.toJson())),
        "recently_viewed":
            List<dynamic>.from(recentlyViewed.map((x) => x.toJson())),
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "sections": List<dynamic>.from(sections.map((x) => x)),
      };
}

class BannerDataNew {
  BannerDataNew({
    this.id,
    this.sortBy,
    this.images,
    this.description,
    this.link,
    this.target,
    this.updatedDate,
    this.createdBy,
    this.updatedBy,
    this.createdDate,
    this.deleted,
    this.status,
    this.bannerType,
    this.bannerValue,
  });

  String id;
  String sortBy;
  String images;
  String description;
  String link;
  String target;
  String updatedDate;
  String createdBy;
  String updatedBy;
  DateTime createdDate;
  String deleted;
  Status status;
  String bannerType;
  dynamic bannerValue;

  factory BannerDataNew.fromJson(Map<String, dynamic> json) => BannerDataNew(
        id: json["id"],
        sortBy: json["sort_by"],
        images: json["images"],
        description: json["description"],
        link: json["link"],
        target: json["target"],
        updatedDate: json["updated_date"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdDate: DateTime.parse(json["created_date"]),
        deleted: json["deleted"],
        status: statusValues.map[json["status"]],
        bannerType: json["banner_type"],
        bannerValue: json["banner_value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sort_by": sortBy,
        "images": images,
        "description": description,
        "link": link,
        "target": target,
        "updated_date": updatedDate,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_date":
            "${createdDate.year.toString().padLeft(4, '0')}-${createdDate.month.toString().padLeft(2, '0')}-${createdDate.day.toString().padLeft(2, '0')}",
        "deleted": deleted,
        "status": statusValues.reverse[status],
        "banner_type": bannerType,
        "banner_value": bannerValue,
      };
}

enum Status { ACTIVE }

final statusValues = EnumValues({"Active": Status.ACTIVE});

class CategoryDataNew {
  CategoryDataNew({
    this.id,
    this.categoryName,
    this.brandName,
    this.image,
    this.status,
    this.createdDate,
    this.updatedDate,
    this.deleted,
    this.sort,
    this.subCategories,
  });

  String id;
  String categoryName;
  BrandName brandName;
  String image;
  Status status;
  DateTime createdDate;
  DateTime updatedDate;
  String deleted;
  String sort;
  List<SubCategoryElement> subCategories;

  factory CategoryDataNew.fromJson(Map<String, dynamic> json) =>
      CategoryDataNew(
        id: json["id"],
        categoryName: json["category_name"],
        brandName: brandNameValues.map[json["brand_name"]],
        image: json["image"],
        status: statusValues.map[json["status"]],
        createdDate: DateTime.parse(json["created_date"]),
        updatedDate: DateTime.parse(json["updated_date"]),
        deleted: json["deleted"],
        sort: json["sort"],
        subCategories: List<SubCategoryElement>.from(
            json["sub_categories"].map((x) => SubCategoryElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
        "brand_name": brandNameValues.reverse[brandName],
        "image": image,
        "status": statusValues.reverse[status],
        "created_date": createdDate.toIso8601String(),
        "updated_date": updatedDate.toIso8601String(),
        "deleted": deleted,
        "sort": sort,
        "sub_categories":
            List<dynamic>.from(subCategories.map((x) => x.toJson())),
      };
}

enum BrandName { ALL, PATHANJALI, MILLETS, PRESTIGE, TIMIOS, CHETAN, AL }

final brandNameValues = EnumValues({
  "Al": BrandName.AL,
  "All": BrandName.ALL,
  "Chetan": BrandName.CHETAN,
  "Millets": BrandName.MILLETS,
  "Pathanjali": BrandName.PATHANJALI,
  "Prestige": BrandName.PRESTIGE,
  "Timios": BrandName.TIMIOS
});

class SubCategoryElement {
  SubCategoryElement({
    this.subCatId,
    this.subCategoryName,
    this.catId,
    this.image,
    this.status,
    this.createdDate,
    this.updatedDate,
    this.deleted,
    this.sort,
    this.childCategories,
    this.childCatId,
    this.childCategoryName,
  });

  String subCatId;
  String subCategoryName;
  String catId;
  String image;
  Status status;
  DateTime createdDate;
  DateTime updatedDate;
  String deleted;
  String sort;
  List<SubCategoryElement> childCategories;
  String childCatId;
  String childCategoryName;

  factory SubCategoryElement.fromJson(Map<String, dynamic> json) =>
      SubCategoryElement(
        subCatId: json["sub_cat_id"],
        subCategoryName: json["sub_category_name"] == null
            ? null
            : json["sub_category_name"],
        catId: json["cat_id"],
        image: json["image"],
        status: statusValues.map[json["status"]],
        createdDate: DateTime.parse(json["created_date"]),
        updatedDate: DateTime.parse(json["updated_date"]),
        deleted: json["deleted"],
        sort: json["sort"],
        childCategories: json["child_categories"] == null
            ? null
            : List<SubCategoryElement>.from(json["child_categories"]
                .map((x) => SubCategoryElement.fromJson(x))),
        childCatId: json["child_cat_id"] == null ? null : json["child_cat_id"],
        childCategoryName: json["child_category_name"] == null
            ? null
            : json["child_category_name"],
      );

  Map<String, dynamic> toJson() => {
        "sub_cat_id": subCatId,
        "sub_category_name": subCategoryName == null ? null : subCategoryName,
        "cat_id": catId,
        "image": image,
        "status": statusValues.reverse[status],
        "created_date": createdDate.toIso8601String(),
        "updated_date": updatedDate.toIso8601String(),
        "deleted": deleted,
        "sort": sort,
        "child_categories": childCategories == null
            ? null
            : List<dynamic>.from(childCategories.map((x) => x.toJson())),
        "child_cat_id": childCatId == null ? null : childCatId,
        "child_category_name":
            childCategoryName == null ? null : childCategoryName,
      };
}

class NewArrival {
  NewArrival({
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
  Location location;
  String productImage;
  String productBannerImage;
  Status status;
  String vendor;
  String msl;
  String mslOld;
  String taxClass;
  String assignedTo;
  DateTime createdDate;
  DateTime updatedDate;
  String deleted;
  String productSubCategory;
  String productChildCategory;
  String varientType;
  String categoryName;
  String subCategoryName;
  String childCategoryName;
  List<ProductPrice> productPrice;
  bool isWishlist;

  factory NewArrival.fromJson(Map<String, dynamic> json) => NewArrival(
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
        location: locationValues.map[json["location"]],
        productImage: json["product_image"],
        productBannerImage: json["product_banner_image"],
        status: statusValues.map[json["status"]],
        vendor: json["vendor"],
        msl: json["msl"],
        mslOld: json["msl_old"] == null ? null : json["msl_old"],
        taxClass: json["tax_class"],
        assignedTo: json["assigned_to"],
        createdDate: DateTime.parse(json["created_date"]),
        updatedDate: DateTime.parse(json["updated_date"]),
        deleted: json["deleted"],
        productSubCategory: json["product_sub_category"],
        productChildCategory: json["product_child_category"],
        varientType: json["varient_type"],
        categoryName: json["category_name"],
        subCategoryName: json["sub_category_name"] == null
            ? null
            : json["sub_category_name"],
        childCategoryName: json["child_category_name"] == null
            ? null
            : json["child_category_name"],
        productPrice: List<ProductPrice>.from(
            json["product_price"].map((x) => ProductPrice.fromJson(x))),
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
        "location": locationValues.reverse[location],
        "product_image": productImage,
        "product_banner_image": productBannerImage,
        "status": statusValues.reverse[status],
        "vendor": vendor,
        "msl": msl,
        "msl_old": mslOld == null ? null : mslOld,
        "tax_class": taxClass,
        "assigned_to": assignedTo,
        "created_date": createdDate.toIso8601String(),
        "updated_date": updatedDate.toIso8601String(),
        "deleted": deleted,
        "product_sub_category": productSubCategory,
        "product_child_category": productChildCategory,
        "varient_type": varientType,
        "category_name": categoryName,
        "sub_category_name": subCategoryName == null ? null : subCategoryName,
        "child_category_name":
            childCategoryName == null ? null : childCategoryName,
        "product_price":
            List<dynamic>.from(productPrice.map((x) => x.toJson())),
        "is_wishlist": isWishlist,
      };
}

enum Location { THE_52, THE_2 }

final locationValues =
    EnumValues({"[\"2\"]": Location.THE_2, "[\"5\",\"2\"]": Location.THE_52});

class ProductPrice {
  ProductPrice({
    this.quantity,
    this.originalprice,
    this.sp,
    this.lcp,
    this.productsInStock,
    this.cartQty,
    this.discountPercentage,
  });

  Quantity quantity;
  String originalprice;
  String sp;
  String lcp;
  String productsInStock;
  int cartQty;
  int discountPercentage;

  factory ProductPrice.fromJson(Map<String, dynamic> json) => ProductPrice(
        quantity: quantityValues.map[json["quantity"]],
        originalprice: json["originalprice"],
        sp: json["sp"],
        lcp: json["lcp"],
        productsInStock: json["products_in_stock"],
        cartQty: json["cartQty"],
        discountPercentage: json["discount_percentage"],
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantityValues.reverse[quantity],
        "originalprice": originalprice,
        "sp": sp,
        "lcp": lcp,
        "products_in_stock": productsInStock,
        "cartQty": cartQty,
        "discount_percentage": discountPercentage,
      };
}

enum Quantity { THE_1_PC, THE_1_KG, THE_1_LT, THE_1_ML }

final quantityValues = EnumValues({
  "1 kg": Quantity.THE_1_KG,
  "1 lt": Quantity.THE_1_LT,
  "1 ml": Quantity.THE_1_ML,
  "1 pc": Quantity.THE_1_PC
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
