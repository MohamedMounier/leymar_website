class TestimonialModel {
  final int id;
  final String name;
  final String company;
  final String country;
  final int rating;
  final String quote;
  final String quoteAr;

  const TestimonialModel({
    required this.id,
    required this.name,
    required this.company,
    required this.country,
    required this.rating,
    required this.quote,
    required this.quoteAr,
  });

  factory TestimonialModel.fromJson(Map<String, dynamic> json) {
    return TestimonialModel(
      id: json['id'] as int,
      name: json['name'] as String,
      company: json['company'] as String,
      country: json['country'] as String,
      rating: json['rating'] as int,
      quote: json['quote'] as String,
      quoteAr: json['quoteAr'] as String,
    );
  }
}
