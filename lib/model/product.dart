// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

// 類別名稱
List catagory = [
  "electronics",
  "jewelery",
  "men's clothing",
  "women's clothing"
];

class ProductModel {
  ProductModel({
    this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    @required this.isFavourite = false,
  });

  final int? id; //
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating? rating;
  bool isFavourite;
  // 若有數值轉換可直接在model導入時轉換
  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        price: json["price"] == null ? null : json["price"].toDouble(),
        description: json["description"] == null ? null : json["description"],
        category: json["category"] == null ? null : json["category"],
        image: json["image"] == null ? null : json["image"],
        rating: json["rating"] == null ? null : Rating.fromJson(json["rating"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "price": price == null ? null : price,
        "description": description == null ? null : description,
        "category": category == null ? null : category,
        "image": image == null ? null : image,
        "rating": rating == null ? null : rating!.toJson(),
      };
}

class Rating {
  Rating({
    required this.rate,
    required this.count,
  });

  double rate;
  int count;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rate: json["rate"] == null ? null : json["rate"].toDouble(),
        count: json["count"] == null ? null : json["count"],
      );

  Map<String, dynamic> toJson() => {
        "rate": rate == null ? null : rate,
        "count": count == null ? null : count,
      };
}
