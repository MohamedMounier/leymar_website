import 'package:equatable/equatable.dart';
import 'package:lymar_sample_project/models/product_model.dart';
import 'package:lymar_sample_project/models/category_model.dart';

enum ProductsStatus { initial, loading, loaded, error }

class ProductsState extends Equatable {
  final ProductsStatus status;
  final List<ProductModel> products;
  final List<ProductModel> filteredProducts;
  final List<CategoryModel> categories;
  final String selectedCategory;
  final String? errorMessage;

  const ProductsState({
    this.status = ProductsStatus.initial,
    this.products = const [],
    this.filteredProducts = const [],
    this.categories = const [],
    this.selectedCategory = 'all',
    this.errorMessage,
  });

  ProductsState copyWith({
    ProductsStatus? status,
    List<ProductModel>? products,
    List<ProductModel>? filteredProducts,
    List<CategoryModel>? categories,
    String? selectedCategory,
    String? errorMessage,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        filteredProducts,
        categories,
        selectedCategory,
        errorMessage,
      ];
}
