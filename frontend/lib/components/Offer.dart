import 'package:http/http.dart' as http;
import 'dart:convert';

class Offer {
  final int id;
  final String title;
  final String description;
  final String stars;
  final String image;

  Offer(this.id, this.title, this.description, this.stars, this.image);

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      json['_id'] as int,
      json['title'] as String,
      json['description'] as String,
      json['stars'] as String,
      json['image'] as String,
    );
  }


}