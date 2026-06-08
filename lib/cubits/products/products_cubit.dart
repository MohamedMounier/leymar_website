import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lymar_sample_project/models/product_model.dart';
import 'package:lymar_sample_project/repositories/products_repository.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepository _repository;

  ProductsCubit({required ProductsRepository repository})
      : _repository = repository,
        super(const ProductsState());

  Future<void> loadProducts() async {
    emit(state.copyWith(status: ProductsStatus.loading));
    try {
      final products = await _repository.loadProducts();
      final categories = await _repository.loadCategories();
      emit(state.copyWith(
        status: ProductsStatus.loaded,
        products: products,
        filteredProducts: products,
        categories: categories,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void filterByCategory(String category) {
    final filtered = category == 'all'
        ? state.products
        : state.products.where((p) => p.category == category).toList();
    emit(state.copyWith(
      filteredProducts: filtered,
      selectedCategory: category,
    ));
  }

  List<ProductModel> get featuredProducts =>
      state.products.where((p) => p.featured).toList();
}
