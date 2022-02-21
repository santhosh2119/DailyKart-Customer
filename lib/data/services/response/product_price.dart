import 'dart:convert';

ProductPrice productPriceFromJson(String str) =>
    ProductPrice.fromJson(json.decode(str));

String productPriceToJson(ProductPrice data) => json.encode(data.toJson());

class ProductPrice {
  ProductPrice(
      {this.quantity,
      this.originalprice,
      this.sp,
      this.lcp,
      this.productsInStock,
      this.cartQty,
      this.discountPercentage,
      this.select});

  String quantity;
  String originalprice;
  String sp;
  String lcp;
  String productsInStock;
  String cartQty;
  int discountPercentage;
  bool select = true;

  factory ProductPrice.fromJson(Map<String, dynamic> json) => ProductPrice(
        quantity: json["quantity"],
        originalprice: json["originalprice"],
        sp: json["sp"],
        lcp: json["lcp"],
        productsInStock: json["products_in_stock"],
        cartQty: json["cartQty"].toString(),
        discountPercentage: json["discount_percentage"],
        select: json["select"] = true,
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "originalprice": originalprice,
        "sp": sp,
        "lcp": lcp,
        "products_in_stock": productsInStock,
        "cartQty": cartQty.toString(),
        "discount_percentage": discountPercentage,
        "select": select= true,
      };
}
