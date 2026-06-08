import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:lymar_sample_project/models/product_model.dart';
import 'package:lymar_sample_project/models/category_model.dart';

class ProductsRepository {
  Future<List<ProductModel>> loadProducts() async {
    final jsonString = await rootBundle.loadString('lib/data/json/products.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((j) => ProductModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<List<CategoryModel>> loadCategories() async {
    final jsonString =
        await rootBundle.loadString('lib/data/json/categories.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((j) => CategoryModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}
