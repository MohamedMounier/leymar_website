class ProductModel {
  final int id;
  final String name;
  final String nameAr;
  final String category;
  final String description;
  final String descriptionAr;
  final Map<String, String> specifications;
  final Map<String, String>? specificationsAr;
  final List<String> applications;
  final List<String>? applicationsAr;

  /// Gallery images for this product (assets to be added later).
  final List<String> images;
  final bool featured;
  final String image;

  const ProductModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.category,
    required this.description,
    required this.descriptionAr,
    required this.specifications,
    this.specificationsAr,
    required this.applications,
    this.applicationsAr,
    required this.images,
    required this.featured,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      nameAr: json['nameAr'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      descriptionAr: json['descriptionAr'] as String,
      specifications: Map<String, String>.from(json['specifications'] as Map),
      specificationsAr: json['specificationsAr'] != null
          ? Map<String, String>.from(json['specificationsAr'] as Map)
          : null,
      applications: List<String>.from(json['applications'] as List),
      applicationsAr: json['applicationsAr'] != null
          ? List<String>.from(json['applicationsAr'] as List)
          : null,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : const [],
      featured: json['featured'] as bool,
      image: json['image'] as String,
    );
  }
}
