import 'package:http/http.dart' as http;
import 'dart:convert';

class Offer {
  final String id;
  final String title;
  final String description;
  final List<dynamic> stars;
  final String img;

  Offer(this.id, this.title, this.description, this.stars, this.img);

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      json['_id'] as String,
      json['title'] as String,
      json['description'] as String,
      json['stars'] as List<dynamic>,
      json['img'] as String,
    );
  }


}