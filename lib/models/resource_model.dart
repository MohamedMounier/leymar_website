class ResourceModel {
  final int id;
  final String title;
  final String titleAr;
  final String excerpt;
  final String excerptAr;
  final String readTime;
  final String date;
  final String category;
  final String image;

  const ResourceModel({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.excerpt,
    required this.excerptAr,
    required this.readTime,
    required this.date,
    required this.category,
    required this.image,
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      id: json['id'] as int,
      title: json['title'] as String,
      titleAr: json['titleAr'] as String,
      excerpt: json['excerpt'] as String,
      excerptAr: json['excerptAr'] as String,
      readTime: json['readTime'] as String,
      date: json['date'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
    );
  }
}
