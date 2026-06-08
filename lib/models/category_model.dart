class CategoryModel {
  final String id;
  final String name;
  final String nameAr;
  final String icon;
  final int productCount;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.icon,
    required this.productCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['nameAr'] as String,
      icon: json['icon'] as String,
      productCount: json['productCount'] as int,
    );
  }
}
