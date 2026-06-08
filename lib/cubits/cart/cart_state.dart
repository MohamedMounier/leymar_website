import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final int productId;
  final String productName;
  final String productNameAr;
  final String category;
  final String selectedColor;
  final String selectedWidth;
  final int quantity;

  const CartItem({
    required this.productId,
    required this.productName,
    required this.productNameAr,
    required this.category,
    required this.selectedColor,
    required this.selectedWidth,
    this.quantity = 1,
  });

  CartItem copyWith({int? quantity, String? selectedColor, String? selectedWidth}) =>
      CartItem(
        productId: productId,
        productName: productName,
        productNameAr: productNameAr,
        category: category,
        selectedColor: selectedColor ?? this.selectedColor,
        selectedWidth: selectedWidth ?? this.selectedWidth,
        quantity: quantity ?? this.quantity,
      );

  @override
  List<Object?> get props => [productId, selectedColor, selectedWidth];
}

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;

  @override
  List<Object?> get props => [items];
}
