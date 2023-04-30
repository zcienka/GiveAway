class Offer {
  final String id;
  final String title;
  final String description;
  final List<dynamic> stars;
  final String img;
  final String location;

  Offer(this.id, this.title, this.description, this.stars, this.img, this.location);

  factory Offer.fromJsonList(Map<String, dynamic> json) {
    return Offer(
      json['id'] as String,
      json['title'] as String,
      json['description'] as String,
      json['stars'] as List<dynamic>,
      json['img'] as String,
      json['location'] as String,
    );
  }

  static List<Offer> fromJsonArray(List<dynamic> json) {
    return json.map((offerJson) => Offer.fromJsonList(offerJson)).toList();
  }
}
