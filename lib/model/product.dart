import 'dart:convert';

import 'package:testapplication/model/rating.dart';

class Product {
  int id;
  String title;
  double price;
  String description;
  String category;
  String image;
  Rating rating;
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating.toMap(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      image: map['image'] ?? '',
      rating: Rating.fromMap(map['rating']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
