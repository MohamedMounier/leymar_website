import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addItem(CartItem item) {
    final idx = state.items.indexWhere(
      (i) =>
          i.productId == item.productId &&
          i.selectedColor == item.selectedColor &&
          i.selectedWidth == item.selectedWidth,
    );
    if (idx >= 0) {
      final list = List<CartItem>.from(state.items);
      list[idx] = list[idx].copyWith(quantity: list[idx].quantity + 1);
      emit(CartState(items: list));
    } else {
      emit(CartState(items: [...state.items, item]));
    }
  }

  void removeAt(int index) {
    final list = List<CartItem>.from(state.items)..removeAt(index);
    emit(CartState(items: list));
  }

  void updateQuantity(int index, int quantity) {
    if (quantity <= 0) {
      removeAt(index);
      return;
    }
    final list = List<CartItem>.from(state.items);
    list[index] = list[index].copyWith(quantity: quantity);
    emit(CartState(items: list));
  }

  void clear() => emit(const CartState());
}
